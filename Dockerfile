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
RUN echo "ANTHROPIC_API_KEY=sk-your-valid-api-key\nVITE_LOG_LEVEL=debug" > /app/.env.local

# Создаём файл для ключа API
RUN mkdir -p /app/config && \
    echo "module.exports = { apiKey: 'sk-your-valid-api-key' };" > /app/config/apiKey.js

# Устанавливаем зависимости и собираем проект
RUN pnpm install
RUN pnpm build

# Указываем порт для приложения
EXPOSE 8788

# Команда для запуска приложения
CMD ["wrangler", "pages", "dev", "./build/client", "--port", "8788", "--ip", "0.0.0.0"]
