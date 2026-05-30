import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../../config/database';
import { env } from '../../config/env';
import { AppError } from '../../middleware/errorHandler';
import { JwtPayload } from '../../middleware/auth';
import { RegisterInput, LoginInput } from './auth.schema';
import { Role } from '@prisma/client';

const SALT_ROUNDS = 12;

function generateTokens(payload: JwtPayload) {
  const accessToken = jwt.sign(payload, env.jwt.secret, {
    expiresIn: env.jwt.expiresIn as jwt.SignOptions['expiresIn'],
  });

  const refreshToken = jwt.sign(payload, env.jwt.refreshSecret, {
    expiresIn: env.jwt.refreshExpiresIn as jwt.SignOptions['expiresIn'],
  });

  return { accessToken, refreshToken };
}

export const authService = {
  async register(data: RegisterInput) {
    const existing = await prisma.user.findFirst({
      where: {
        OR: [{ email: data.email }, { phone: data.phone }],
      },
    });

    if (existing) {
      if (existing.email === data.email) {
        throw new AppError('Cet email est déjà utilisé', 409);
      }
      throw new AppError('Ce numéro de téléphone est déjà utilisé', 409);
    }

    const hashedPassword = await bcrypt.hash(data.password, SALT_ROUNDS);

    const user = await prisma.user.create({
      data: {
        email: data.email,
        phone: data.phone,
        password: hashedPassword,
        firstName: data.firstName,
        lastName: data.lastName,
        role: data.role as Role,
      },
      select: {
        id: true,
        email: true,
        phone: true,
        firstName: true,
        lastName: true,
        role: true,
        avatar: true,
        isVerified: true,
        createdAt: true,
      },
    });

    const tokens = generateTokens({
      userId: user.id,
      role: user.role,
      email: user.email,
    });

    await prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: tokens.refreshToken },
    });

    return { user, ...tokens };
  },

  async login(data: LoginInput) {
    const user = await prisma.user.findUnique({
      where: { email: data.email },
    });

    if (!user) {
      throw new AppError('Email ou mot de passe incorrect', 401);
    }

    if (!user.isActive) {
      throw new AppError('Votre compte a été désactivé', 403);
    }

    const isPasswordValid = await bcrypt.compare(data.password, user.password);

    if (!isPasswordValid) {
      throw new AppError('Email ou mot de passe incorrect', 401);
    }

    const tokens = generateTokens({
      userId: user.id,
      role: user.role,
      email: user.email,
    });

    await prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: tokens.refreshToken },
    });

    const { password, refreshToken: _, ...userWithoutSensitive } = user;

    return { user: userWithoutSensitive, ...tokens };
  },

  async refreshToken(token: string) {
    let decoded: JwtPayload;

    try {
      decoded = jwt.verify(token, env.jwt.refreshSecret) as JwtPayload;
    } catch {
      throw new AppError('Refresh token invalide ou expiré', 401);
    }

    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: { id: true, role: true, email: true, refreshToken: true, isActive: true },
    });

    if (!user || user.refreshToken !== token || !user.isActive) {
      throw new AppError('Refresh token invalide', 401);
    }

    const tokens = generateTokens({
      userId: user.id,
      role: user.role,
      email: user.email,
    });

    await prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: tokens.refreshToken },
    });

    return tokens;
  },

  async logout(userId: string) {
    await prisma.user.update({
      where: { id: userId },
      data: { refreshToken: null },
    });
  },

  async changePassword(userId: string, currentPassword: string, newPassword: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });

    if (!user) {
      throw new AppError('Utilisateur introuvable', 404);
    }

    const isValid = await bcrypt.compare(currentPassword, user.password);

    if (!isValid) {
      throw new AppError('Mot de passe actuel incorrect', 400);
    }

    const hashedPassword = await bcrypt.hash(newPassword, SALT_ROUNDS);

    await prisma.user.update({
      where: { id: userId },
      data: { password: hashedPassword, refreshToken: null },
    });
  },
};
