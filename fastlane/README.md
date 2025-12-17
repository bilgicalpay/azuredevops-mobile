# Fastlane Configuration

Bu klasör Flutter Android uygulaması için Fastlane yapılandırmasını içerir.

## Kurulum

1. Fastlane'ı yükleyin:
```bash
# macOS
sudo gem install fastlane

# veya Homebrew ile
brew install fastlane
```

2. Android klasöründe Fastlane'ı başlatın (opsiyonel):
```bash
cd android
fastlane init
```

## Kullanım

### Temel Komutlar

```bash
# APK build et
fastlane android build_apk

# App Bundle (AAB) build et
fastlane android build_aab

# Testleri çalıştır
fastlane android test

# Kod analizi yap
fastlane android analyze

# Beta build ve deploy
fastlane android beta

# Production build ve deploy
fastlane android release

# Temizle
fastlane android clean
```

## Yapılandırma

### Appfile
`Appfile` dosyasında uygulama paket adını ve Google Play Store ayarlarını yapılandırın.

### Google Play Store Deploy

Production deploy için Google Play Store servis hesabı anahtarı gerekir:

1. Google Play Console'da servis hesabı oluşturun
2. JSON anahtar dosyasını indirin
3. `Appfile` içinde `json_key_file` yolunu belirtin
4. `Fastfile` içindeki `upload_to_play_store` satırlarının yorumunu kaldırın

## CI/CD Entegrasyonu

Fastlane, GitLab CI/CD, GitHub Actions ve Jenkins pipeline'larında kullanılabilir. 
Her platform için örnek kullanım ilgili klasörlerdeki dosyalarda bulunmaktadır.

