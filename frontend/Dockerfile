FROM node:20-alpine AS base

#Install dependencies and build
FROM base AS builder
WORKDIR /app
COPY . .
RUN npm ci && npm run build

#Runner stage
FROM base AS runner
WORKDIR /app
ENV NODE_ENV production
# ★ここを追加（自動化のポイント）
ENV HOSTNAME "0.0.0.0"
ENV PORT 3000

#Next.js standalone出力を利用（軽量化のコツ）
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

EXPOSE 3000
CMD ["node", "server.js"]