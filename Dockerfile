# Используем официальный образ Rust для сборки
FROM rust:1.70 AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем исходный код
COPY . .

# Устанавливаем зависимости и собираем проект
RUN cargo build --release

# Используем минимальный образ для запуска
FROM debian:bullseye-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный бинарник из этапа сборки
COPY --from=build /app/target/release/polaris /app/polaris

# Копируем статические файлы (если они есть)
# COPY static /app/static

# Копируем конфигурацию (если она существует)
COPY config /app/config

# Открываем порт, который использует Polaris (по умолчанию 5050)
EXPOSE 5050

# Команда для запуска приложения
CMD ["./polaris"]
