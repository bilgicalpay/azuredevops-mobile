# GitLab CI/CD Configuration

Bu klasör GitLab CI/CD pipeline yapılandırmasını içerir.

## Dosya Yapısı

- `.gitlab-ci.yml` - Ana pipeline yapılandırma dosyası (proje kök dizininde)

## Pipeline Aşamaları

### 1. Test Stage
- **test:lint** - Flutter kod analizi (analyze)
- **test:unit** - Unit testlerin çalıştırılması

### 2. Build Stage
- **build:apk** - Release APK oluşturma
- **build:aab** - App Bundle (AAB) oluşturma (Play Store için)

### 3. Deploy Stage
- **deploy:beta** - Beta ortamına deploy (manuel)
- **deploy:production** - Production ortamına deploy (manuel)

## Kullanım

### Otomatik Tetikleme

Pipeline şu durumlarda otomatik çalışır:
- `main` veya `develop` branch'ine push
- Merge request oluşturulduğunda
- Tag oluşturulduğunda

### Manuel Deploy

Deploy aşamaları manuel olarak tetiklenir:
1. GitLab UI'da pipeline sayfasına gidin
2. İlgili deploy job'unu seçin
3. "Play" butonuna tıklayın

## Yapılandırma

### Flutter Versiyonu

`.gitlab-ci.yml` dosyasındaki `FLUTTER_VERSION` değişkenini güncelleyin:
```yaml
variables:
  FLUTTER_VERSION: "3.24.0"
```

### Java Versiyonu

Java versiyonunu değiştirmek için:
```yaml
variables:
  JAVA_VERSION: "17"
```

### Artifact Saklama

Build artifact'ları 1 hafta saklanır. Süreyi değiştirmek için:
```yaml
artifacts:
  expire_in: 1 week  # 1 day, 1 month, vb.
```

## Fastlane Entegrasyonu

Deploy aşamaları Fastlane kullanır. Fastlane yapılandırması için `fastlane/` klasörüne bakın.

## CI/CD Runner Gereksinimleri

GitLab Runner'da şunlar yüklü olmalıdır:
- Git
- Curl
- Unzip
- Java JDK 17
- Flutter SDK (otomatik yüklenir)

## Özel Runner Kullanımı

Daha hızlı build için özel runner kullanabilirsiniz:

1. GitLab Runner'ı yükleyin
2. Runner'ı projeye kaydedin
3. `.gitlab-ci.yml` dosyasında `tags` ekleyin:
```yaml
build:apk:
  tags:
    - android
    - flutter
```

## Sorun Giderme

### Flutter Doctor Hataları

Eğer `flutter doctor` hatalar veriyorsa, gerekli toolchain'leri yükleyin:
- Android SDK
- Android licenses kabul edilmeli

### Java Versiyon Hatası

Java versiyonu uyuşmazlığında, `JAVA_HOME` değişkenini kontrol edin.

### Build Timeout

Büyük projelerde timeout olabilir. GitLab proje ayarlarından timeout süresini artırın.

