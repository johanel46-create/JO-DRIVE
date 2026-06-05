import type { Config } from 'tailwindcss'
const config: Config = {
  content: ['./src/**/*.{js,ts,jsx,tsx,mdx}'],
  theme: {
    extend: {
      colors: {
        primary: '#E30613',
        background: '#0A0A0A',
        surface: '#1A1A1A',
        border: '#2A2A2A',
      }
    }
  },
  plugins: []
}
export default config
