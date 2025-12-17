# Jenkins CI/CD Configuration

Bu klasör Jenkins CI/CD pipeline yapılandırmasını içerir.

## Dosyalar

- **Jenkinsfile** - Ana pipeline tanımı (Declarative Pipeline)
- **config.xml** - Jenkins job yapılandırma şablonu (referans için)

## Kurulum

### 1. Jenkins Plugin'leri

Aşağıdaki plugin'lerin yüklü olduğundan emin olun:

- Pipeline
- Git
- AnsiColor
- Email Extension (opsiyonel)
- Build Timestamp (opsiyonel)

### 2. JDK Kurulumu

Jenkins'te JDK 17'yi yapılandırın:

1. Jenkins > Manage Jenkins > Global Tool Configuration
2. JDK bölümünde "JDK installations"
3. "Add JDK" butonuna tıklayın
4. Name: `JDK-17`
5. JAVA_HOME path'ini belirtin

### 3. Job Oluşturma

#### Yöntem 1: Pipeline Job (Önerilen)

1. Jenkins > New Item
2. "Pipeline" seçin
3. Job adını girin (örn: `azuredevops-onprem-android`)
4. "Pipeline" sekmesine gidin
5. Definition: "Pipeline script from SCM"
6. SCM: Git
7. Repository URL'i girin
8. Script Path: `jenkins/Jenkinsfile`
9. Kaydedin

#### Yöntem 2: Freestyle Job

1. Jenkins > New Item
2. "Freestyle project" seçin
3. "Build" bölümünde "Add build step" > "Execute shell"
4. Jenkinsfile'ı manuel olarak çalıştırın veya pipeline script'i ekleyin

## Pipeline Aşamaları

### 1. Checkout
- Git repository'den kodu çeker
- Git commit hash'ini environment variable'a kaydeder

### 2. Setup Flutter
- Flutter SDK'yı yükler (eğer yoksa)
- Flutter doctor çalıştırır

### 3. Dependencies
- Flutter paketlerini yükler (`flutter pub get`)

### 4. Test
- **Lint**: Flutter analyze çalıştırır
- **Unit Tests**: Flutter test çalıştırır
- Paralel olarak çalışır

### 5. Build APK
- Release APK oluşturur
- Artifact olarak saklar
- `main`, `develop` branch'leri veya tag'ler için çalışır

### 6. Build AAB
- App Bundle (AAB) oluşturur
- Artifact olarak saklar
- `main` branch veya tag'ler için çalışır

### 7. Deploy Beta
- Fastlane ile beta ortamına deploy eder
- Sadece `develop` branch için çalışır
- `DEPLOY_BETA=true` parametresi gerekir

### 8. Deploy Production
- Fastlane ile production ortamına deploy eder
- `main` branch veya tag'ler için çalışır
- Manuel onay gerektirir
- `DEPLOY_PRODUCTION=true` parametresi gerekir

## Kullanım

### Otomatik Tetikleme

Pipeline şu durumlarda otomatik çalışır:
- SCM polling (her 15 dakikada bir)
- Git push (webhook ile)
- Manuel tetikleme

### Manuel Tetikleme

1. Jenkins'te job'u açın
2. "Build with Parameters" seçin
3. Parametreleri ayarlayın:
   - `DEPLOY_BETA`: Beta deploy için
   - `DEPLOY_PRODUCTION`: Production deploy için
   - `FLUTTER_VERSION`: Flutter versiyonu
4. "Build" butonuna tıklayın

### Branch ve Tag Filtreleme

Pipeline sadece belirli branch'lerde çalışır:
- `main`: Production build ve deploy
- `develop`: Beta build ve deploy
- `tags/v*`: Release build ve deploy

## Yapılandırma

### Environment Variables

Pipeline'da kullanılan environment variables:

```groovy
FLUTTER_VERSION = '3.24.0'
JAVA_HOME = tool('JDK-17')
ANDROID_HOME = "${env.WORKSPACE}/android-sdk"
```

### Build Options

```groovy
timeout(time: 60, unit: 'MINUTES')  // Build timeout
buildDiscarder(logRotator(numToKeepStr: '10'))  // Build history
```

### Artifact Saklama

Build artifact'ları otomatik olarak saklanır:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### Email Bildirimleri

Build başarısız olduğunda email gönderilir. Yapılandırmak için:

1. Jenkins > Manage Jenkins > Configure System
2. "Extended E-mail Notification" bölümünü yapılandırın
3. SMTP ayarlarını girin

## Fastlane Entegrasyonu

Deploy aşamaları Fastlane kullanır. Fastlane yapılandırması için `fastlane/` klasörüne bakın.

### Google Play Store Deploy

1. Google Play Console'da servis hesabı oluşturun
2. JSON anahtar dosyasını Jenkins credentials'a ekleyin
3. Fastlane Appfile'da yapılandırın

## Sorun Giderme

### Flutter SDK Bulunamıyor

Flutter SDK otomatik yüklenir. Manuel yüklemek için:

```bash
git clone https://github.com/flutter/flutter.git -b 3.24.0
export PATH="$PATH:/path/to/flutter/bin"
```

### Java Versiyon Hatası

JDK 17'nin doğru yapılandırıldığından emin olun:
- Jenkins > Manage Jenkins > Global Tool Configuration
- JDK installations bölümünü kontrol edin

### Build Timeout

Timeout süresini artırmak için Jenkinsfile'da:
```groovy
timeout(time: 120, unit: 'MINUTES')
```

### Artifact Bulunamıyor

Artifact path'lerini kontrol edin:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### Permission Hataları

Jenkins user'ın gerekli izinlere sahip olduğundan emin olun:
- Git repository erişimi
- File system yazma izni
- Android SDK erişimi (eğer yüklüyse)

## Best Practices

1. **Build History**: Eski build'leri temizleyin (disk alanı için)
2. **Parallel Execution**: Test aşamalarını paralel çalıştırın
3. **Artifact Retention**: Artifact'ları uygun süre saklayın
4. **Security**: Credentials'ları Jenkins credentials store'da saklayın
5. **Monitoring**: Build durumunu izleyin ve bildirimleri yapılandırın

## Örnek Kullanım

### Development Build
```bash
# Jenkins UI'dan
1. Job'u açın
2. "Build with Parameters"
3. DEPLOY_BETA: false
4. Build
```

### Production Release
```bash
# Git tag oluştur
git tag v1.0.0
git push origin v1.0.0

# Jenkins'te
1. Job otomatik tetiklenir
2. Build tamamlandıktan sonra
3. "Build with Parameters"
4. DEPLOY_PRODUCTION: true
5. Manuel onay verin
6. Build
```

