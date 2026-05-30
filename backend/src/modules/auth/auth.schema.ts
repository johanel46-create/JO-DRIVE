import { z } from 'zod';

export const registerSchema = z.object({
  body: z.object({
    email: z.string().email('Email invalide'),
    phone: z
      .string()
      .min(10, 'Numéro de téléphone invalide')
      .regex(/^(\+594|0594|594)[0-9]{6}$|^0[67][0-9]{8}$/, 'Numéro de téléphone invalide'),
    password: z
      .string()
      .min(8, 'Le mot de passe doit contenir au moins 8 caractères')
      .regex(/(?=.*[A-Z])/, 'Le mot de passe doit contenir une majuscule')
      .regex(/(?=.*[0-9])/, 'Le mot de passe doit contenir un chiffre'),
    firstName: z.string().min(2, 'Prénom trop court').max(50),
    lastName: z.string().min(2, 'Nom trop court').max(50),
    role: z.enum(['CLIENT', 'TRANSPORTEUR']).default('CLIENT'),
  }),
});

export const loginSchema = z.object({
  body: z.object({
    email: z.string().email('Email invalide'),
    password: z.string().min(1, 'Mot de passe requis'),
  }),
});

export const refreshSchema = z.object({
  body: z.object({
    refreshToken: z.string().min(1, 'Refresh token requis'),
  }),
});

export const changePasswordSchema = z.object({
  body: z.object({
    currentPassword: z.string().min(1, 'Mot de passe actuel requis'),
    newPassword: z
      .string()
      .min(8, 'Le mot de passe doit contenir au moins 8 caractères')
      .regex(/(?=.*[A-Z])/, 'Le mot de passe doit contenir une majuscule')
      .regex(/(?=.*[0-9])/, 'Le mot de passe doit contenir un chiffre'),
  }),
});

export type RegisterInput = z.infer<typeof registerSchema>['body'];
export type LoginInput = z.infer<typeof loginSchema>['body'];
export type RefreshInput = z.infer<typeof refreshSchema>['body'];
export type ChangePasswordInput = z.infer<typeof changePasswordSchema>['body'];
