# Flutter Web portfolio migration

This branch contains the Flutter Web recreation of the existing static portfolio.

## What is preserved

- Dark/light visual system and the original green/blue palette
- Fixed glass navigation bar
- Responsive breakpoints matching the original 980px / 720px / 470px behavior
- Hero, profile, stats, about, education, training, skills, experience, projects, packages, research, contact and footer sections
- Typing animation, pulse indicator, hover movement and back-to-top behavior
- Existing CV and certificate PDF assets
- External GitHub, LinkedIn, pub.dev, Play Store, App Store, WhatsApp and publication links
- Firebase Analytics + Firestore visitor tracking from the original site
- Google Search Console verification file

## Run locally

```bash
flutter pub get
flutter run -d chrome
```

## Production build

```bash
flutter build web --release
```

The output is generated in `build/web`.

The original static HTML remains untouched on the `main` branch while this version is reviewed.
