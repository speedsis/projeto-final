# Estágio 1: Base
FROM node:18 as base

WORKDIR /snailycad

# Instale o pnpm
RUN curl -fsSL https://get.pnpm.io/install.sh | sh -s -- --version latest

# Adicione o pnpm ao PATH
ENV PATH="/snailycad/node_modules/.bin:$PATH"

# Estágio 2: Dependências
FROM base as deps

COPY package.json pnpm-lock.yaml ./

# Instale as dependências
RUN pnpm install

# Estágio 3: API
FROM deps as api

COPY . .

ENV NODE_ENV="production"

# Executa a construção da API
RUN pnpm turbo run build --filter=@snailycad/api

WORKDIR /snailycad/apps/api

CMD ["pnpm", "start"]

# Estágio 4: Cliente
FROM deps as client

COPY . .

ENV NODE_ENV="production"

# Limpa a pasta .next do cliente
RUN rm -rf /snailycad/apps/client/.next

# Executa a criação de imagens de domínio do cliente
RUN pnpm create-images-domain

# Executa a construção do cliente
RUN pnpm turbo run build --filter=@snailycad/client

WORKDIR /snailycad/apps/client

CMD ["pnpm", "start"]


# FROM node:18 as base

# RUN npm install -g pnpm

# RUN pnpm config set httpTimeout 1200000

# WORKDIR /snailycad

# # Instale o pnpm
# RUN curl -fsSL https://get.pnpm.io/install.sh | sh -s -- --version latest

# # Adicione o pnpm ao PATH
# ENV PATH="/snailycad/node_modules/.bin:$PATH"

# COPY . ./

# FROM base as deps

# RUN pnpm install

# FROM deps as api

# ENV NODE_ENV="production"

# RUN pnpm turbo run build --filter=@snailycad/api

# WORKDIR /snailycad/apps/api

# CMD ["pnpm", "start"]

# FROM deps as client

# ENV NODE_ENV="production"

# RUN rm -rf /snailycad/apps/client/.next

# RUN pnpm create-images-domain

# RUN pnpm turbo run build --filter=@snailycad/client

# WORKDIR /snailycad/apps/client

# CMD ["pnpm", "start"]