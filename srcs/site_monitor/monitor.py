import os
import time
import requests
import sys

SITES = os.getenv("SITES", "https://localhost").split(",")
TELEGRAM_TOKEN = os.getenv("TELEGRAM_TOKEN")
TELEGRAM_CHAT_ID = os.getenv("TELEGRAM_CHAT_ID")
CHECK_INTERVAL = int(os.getenv("CHECK_INTERVAL", 300))

def send_telegram(message):
    print(f"📨 {message}")  # вывод в лог
    if not TELEGRAM_TOKEN or not TELEGRAM_CHAT_ID:
        print("❌ Telegram token or chat_id missing!")
        return
    url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage"
    payload = {"chat_id": TELEGRAM_CHAT_ID, "text": message}
    try:
        r = requests.post(url, data=payload, timeout=10)
        print(f"💬 Telegram API response: {r.status_code} {r.text}")
    except Exception as e:
        print(f"❌ Failed to send Telegram message: {e}")

if __name__ == "__main__":
    if "--startup" in sys.argv:
        send_telegram("✅ Site monitor container started and running.")
        sys.exit(0)

    while True:
        for site in SITES:
            try:
                r = requests.get(site, timeout=10)
                if r.status_code >= 400:
                    send_telegram(f"⚠ Site DOWN: {site} (Status {r.status_code})")
                else:
                    print(f"✅ Site OK: {site} (Status {r.status_code})")
            except Exception as e:
                send_telegram(f"⚠ Site DOWN: {site} ({e})")
        time.sleep(CHECK_INTERVAL)