# Используем Node.js 18 как базовый образ
FROM node:18

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем pnpm и wrangler
RUN npm install -g pnpm wrangler@3.103.2

# Копируем проект в контейнер
COPY . .

# Создаём файл конфигурации моделей
RUN mkdir -p /app/app && \
    echo '[ \
        { \
            "provider": "anthropic", \
            "model": "claude-3-5-sonnet-20240620", \
            "capt": "Claude 3.5" \
        } \
    ]' > /app/app/llms.json

# Создаём файл для локального окружения
RUN echo "ANTHROPIC_API_KEY=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\nVITE_LOG_LEVEL=debug" > .env.local.docker

# Создаём файл для ключа API
RUN mkdir -p /app/config && \
    echo "module.exports = { apiKey: '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' };" > /app/config/apiKey.js

# Устанавливаем зависимости и собираем проект
RUN pnpm install
RUN pnpm build

# Указываем порт для приложения
EXPOSE 8789

# Команда для запуска приложения с передачей ключа API
CMD ["wrangler", "pages", "dev", "./build/client", "--port", "8789", "--ip", "0.0.0.0", "--binding", "ANTHROPIC_API_KEY=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"]
