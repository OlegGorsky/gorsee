# Используем Node.js 18 как базовый образ
FROM node:18

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем pnpm и wrangler
RUN npm install -g pnpm wrangler@3.103.2

# Копируем проект в контейнер
COPY . .

# Создаем файл конфигурации моделей
RUN mkdir -p /app/app && \
    echo '[ \
        { \
            "provider": "anthropic", \
            "model": "claude-3-5-sonnet-20240620", \
            "capt": "Claude 3.5" \
        } \
    ]' > /app/app/llms.json

# Устанавливаем зависимости и собираем проект
RUN pnpm install
RUN pnpm build

# Указываем порт для приложения
EXPOSE 8789

# Команда для запуска приложения
CMD ["wrangler", "pages", "dev", "./build/client", "--port", "8789", "--ip", "0.0.0.0"]
