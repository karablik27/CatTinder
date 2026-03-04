# CatTinder Pro — приложение для свайпа котиков

**CatTinder** — Flutter-приложение с Tinder-подобным интерфейсом для просмотра котиков и пород.

Приложение загружает случайных котов из TheCatAPI, позволяет лайкать/дизлайкать, смотреть детали породы, генерировать имя по фото через AI, а также включает авторизацию, онбординг и аналитику.

---

## Актуальный стек и архитектура

- Flutter + Provider
- Clean Architecture: `Data / Domain / Presentation`
- Централизованный DI/Composition Root (`AppScope`)
- Локальное безопасное хранение (Keychain/Keystore) через `flutter_secure_storage`
- Analytics: AppMetrica + Firebase Analytics

---

## Реализованные фичи

### Основной флоу котиков
- Загрузка случайных котиков из **TheCatAPI**
- Свайп вправо/влево + кнопки лайк/дизлайк
- Счётчик лайков
- Переход в детальный экран кота

### Породы
- Отдельная вкладка с таблицей/списком пород
- Fuzzy-поиск по названию и стране происхождения
- Детальный экран породы: описание, страна, темперамент, рейтинги

### AI-генерация имени
- Интеграция с **OpenRouter**
- Генерация короткого имени по фото кота
- Отображение имени в карточке и на детальном экране

### Авторизация (ДЗ-2)
- Экраны `Login` и `Sign Up`
- Валидация полей (email, длина пароля, совпадение паролей)
- Успешный вход переводит в основной флоу
- Состояние авторизации переживает перезапуск приложения
- Кнопка выхода (`logout`) в основном флоу

### Онбординг (ДЗ-2)
- Показывается при первом запуске до завершения
- Горизонтальный pager из 3 шагов
- Шаги объясняют: свайпы, детали кота, вкладку пород
- Используются изображения:
  - `assets/onboarding_cat1.png`
  - `assets/onboarding_cat2.png`
  - `assets/onboarding_cat3.png`
- Есть заметная анимация котика при перелистывании (translate/scale/rotate)

### Аналитика (ДЗ-2)
- Отправка auth-событий одновременно в **AppMetrica** и **Firebase Analytics**
- События:
  - `auth_login_success`, `auth_login_error`
  - `auth_signup_success`, `auth_signup_error`
- Параметры: `email_domain`, `reason` (для ошибок)

### Тесты (ДЗ-2)
- Unit-тесты на ключевую auth-логику (успех/ошибка, статус)
- Widget-тесты на auth-сценарии (валидация, успешная регистрация и изменение состояния)

---

## Скриншоты приложения

![5305379711716364175](https://github.com/user-attachments/assets/d775ad19-611f-4958-8081-0b58a80e8f7b)
![5305379711716364172](https://github.com/user-attachments/assets/fd4a3ff4-751f-413d-abc9-95317e3b3c89)
![5305379711716364174 (4)](https://github.com/user-attachments/assets/70229a76-9f2b-4d79-959d-2bb92a6f512f)
![5305379711716364173 (4)](https://github.com/user-attachments/assets/e039639c-5ac7-49b2-9650-07522693c303)
![5305379711716364171 (3)](https://github.com/user-attachments/assets/2253c0ad-2f93-416e-9e2d-7c6dbb4a9436)
<img width="919" height="517" alt="Снимок экрана 2026-03-04 в 23 54 48" src="https://github.com/user-attachments/assets/0e6c99f4-183b-4e37-a71d-777e04624213" />
https://github.com/user-attachments/assets/a25b80fd-2051-4dc0-b0cb-7497e175aa31


---

## Скачать APK

**[Скачать последнюю версию APK](https://github.com/karablik27/CatTinder/releases/download/pro/app-release.apk)**  

---

## Установка и запуск

```bash
git clone https://github.com/USERNAME/cattinder
cd cattinder
flutter pub get
cp secrets.example.json secrets.json
flutter run --dart-define-from-file=secrets.json
```

Ключи API не хранятся в коде и передаются через `--dart-define`.
