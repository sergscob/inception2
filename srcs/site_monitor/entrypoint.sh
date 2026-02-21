#!/bin/sh
set -e

echo "🚀 Starting site monitor container..."

# Активируем виртуальное окружение
. /venv/bin/activate

# Отправка уведомления при старте
python /app/monitor.py --startup

# Запуск основного мониторинга
python /app/monitor.py