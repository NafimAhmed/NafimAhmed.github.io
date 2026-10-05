class TrainingItem {
  const TrainingItem({
    required this.icon,
    required this.type,
    required this.title,
    required this.description,
    required this.metadata,
    required this.topics,
    required this.certificateUrl,
    this.verifyUrl,
  });

  final String icon;
  final String type;
  final String title;
  final String description;
  final List<MapEntry<String, String>> metadata;
  final List<String> topics;
  final String certificateUrl;
  final String? verifyUrl;
}

class SkillGroup {
  const SkillGroup({
    required this.number,
    required this.title,
    required this.skills,
  });

  final String number;
  final String title;
  final List<String> skills;
}

class ExperienceItem {
  const ExperienceItem({
    required this.dot,
    required this.title,
    required this.company,
    required this.badge,
    required this.description,
  });

  final String dot;
  final String title;
  final String company;
  final String badge;
  final String description;
}

class ProjectLink {
  const ProjectLink(this.label, this.url, {this.kind = 'default'});

  final String label;
  final String url;
  final String kind;
}

class ProjectItem {
  const ProjectItem({
    required this.type,
    required this.status,
    required this.title,
    required this.description,
    required this.tech,
    required this.links,
  });

  final String type;
  final String status;
  final String title;
  final String description;
  final List<String> tech;
  final List<ProjectLink> links;
}

class PackageItem {
  const PackageItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });

  final String icon;
  final String title;
  final String description;
  final String url;
}

class PublicationItem {
  const PublicationItem({
    required this.year,
    required this.title,
    required this.description,
    required this.url,
    required this.linkLabel,
  });

  final String year;
  final String title;
  final String description;
  final String url;
  final String linkLabel;
}

const typingPhrases = <String>[
  'scalable Flutter applications',
  'enterprise ERP mobile solutions',
  'AI-powered product experiences',
  'connected IoT and automation systems',
  'developer-friendly Flutter packages',
];

const trainingItems = <TrainingItem>[
  TrainingItem(
    icon: 'AI',
    type: 'Ostad • Certificate of Assessment',
    title: 'AI Engineering Bootcamp for Programmers',
    description:
        'Successfully completed the online live AI Engineering Bootcamp for Programmers with Batch 2 and received a vetted certificate of assessment.',
    metadata: [
      MapEntry('Issuer', 'Ostad Ltd.'),
      MapEntry('Credential ID', 'A36428'),
      MapEntry('Assessment', 'Quiz 94.1% • Assignment 60%'),
    ],
    topics: ['AI Engineering', 'Programming', 'Assessment', 'Batch 2'],
    certificateUrl: 'assets/assets/ai-engineering-bootcamp-ostad.pdf',
  ),
  TrainingItem(
    icon: 'ISO',
    type: 'B-ADVANCY • Awareness Training',
    title: 'ISO 9001:2015 (QMS) & ISO 27001:2022 (ISMS)',
    description:
        'Completed awareness training on quality management and information security management systems at Pakiza Software Ltd., Dhaka.',
    metadata: [
      MapEntry('Training dates', '05 February & 03 March 2024'),
      MapEntry('Issue date', '20 March 2024'),
      MapEntry('Certificate No.', 'BAC-PSL/2403-07'),
    ],
    topics: ['ISO 9001:2015', 'QMS', 'ISO 27001:2022', 'ISMS'],
    certificateUrl: 'assets/assets/iso-awareness-training-b-advancy.pdf',
  ),
  TrainingItem(
    icon: 'AR',
    type: 'Coursera • Google AR & VR',
    title: 'Introduction to Augmented Reality and ARCore',
    description:
        'Completed an online non-credit course authorized by Google AR & VR and offered through Coursera.',
    metadata: [
      MapEntry('Completion date', '16 October 2020'),
      MapEntry('Credential ID', 'AADKWKBMV4RX'),
      MapEntry('Provider', 'Google AR & VR / Coursera'),
    ],
    topics: ['Augmented Reality', 'ARCore', 'Google AR & VR', 'Coursera'],
    certificateUrl:
        'assets/assets/introduction-to-augmented-reality-arcore-coursera.pdf',
    verifyUrl: 'https://coursera.org/verify/AADKWKBMV4RX',
  ),
  TrainingItem(
    icon: 'APP',
    type: 'Udemy • Certificate of Completion',
    title: 'The Complete Flutter Development Bootcamp with Dart',
    description:
        'Completed a 29-hour Flutter and Dart development course instructed by Dr. Angela Yu.',
    metadata: [
      MapEntry('Completion date', '11 August 2023'),
      MapEntry('Course length', '29 total hours'),
      MapEntry(
        'Certificate No.',
        'UC-8aeeb52b-cad4-4ff0-902b-7b13884eee12',
      ),
    ],
    topics: ['Flutter', 'Dart', 'Mobile Development', 'Udemy'],
    certificateUrl:
        'assets/assets/complete-flutter-development-bootcamp-udemy.pdf',
    verifyUrl: 'https://ude.my/UC-8aeeb52b-cad4-4ff0-902b-7b13884eee12',
  ),
];

const skillGroups = <SkillGroup>[
  SkillGroup(
    number: '01 / MOBILE',
    title: 'Mobile Development',
    skills: [
      'Flutter',
      'Dart',
      'Android Native',
      'Kotlin',
      'Java',
      'Swift',
      'React Native',
    ],
  ),
  SkillGroup(
    number: '02 / ARCHITECTURE',
    title: 'Application Architecture',
    skills: [
      'BLoC / Cubit',
      'Clean Architecture',
      'MVVM',
      'GetX',
      'Dependency Injection',
      'Offline First',
    ],
  ),
  SkillGroup(
    number: '03 / BACKEND',
    title: 'Backend and APIs',
    skills: [
      'REST API',
      'FastAPI',
      'Flask',
      'Python',
      'Go',
      'Socket.IO',
      'WebSocket',
    ],
  ),
  SkillGroup(
    number: '04 / ERP',
    title: 'Enterprise and Data',
    skills: [
      'Oracle EBS',
      'Oracle ORDS',
      'PL/SQL',
      'Firebase',
      'MongoDB',
      'Hive',
      'SQL',
    ],
  ),
  SkillGroup(
    number: '05 / AI',
    title: 'AI and Computer Vision',
    skills: [
      'TensorFlow',
      'TFLite',
      'OpenCV',
      'Scikit-learn',
      'ML Kit',
      'Chatbots',
      'Model Deployment',
    ],
  ),
  SkillGroup(
    number: '06 / HARDWARE',
    title: 'IoT and Device Integration',
    skills: [
      'ESP32',
      'MicroPython',
      'Arduino',
      'RFID',
      'NFC',
      'QR / Barcode',
      'Thermal Printing',
    ],
  ),
];

const experienceItems = <ExperienceItem>[
  ExperienceItem(
    dot: 'NOW',
    title: 'Software Engineer / Assistant Manager',
    company: 'PRAN-RFL Group',
    badge: 'Enterprise',
    description:
        'Developing Express ERP and other mobile solutions integrated with Oracle EBS and ORDS. Working on inventory, production, quality, market operations, display room, QR workflows, printing and role-based enterprise modules.',
  ),
  ExperienceItem(
    dot: 'AI',
    title: 'AI Application and Chatbot Development',
    company: 'Product and R&D Work',
    badge: 'Innovation',
    description:
        'Building intelligent chatbots, computer-vision prototypes, classification systems, interview agents and AI-powered mobile features using Python, TensorFlow, OpenCV and Flutter.',
  ),
  ExperienceItem(
    dot: 'APP',
    title: 'Commercial Mobile Application Development',
    company: 'Cross-platform Products',
    badge: 'Mobile',
    description:
        'Delivered ERP, ride-sharing, e-commerce, payment, travel and utility applications with authentication, maps, tracking, API integrations, push notifications and store deployment.',
  ),
  ExperienceItem(
    dot: 'OSS',
    title: 'Open-source Flutter Package Author',
    company: 'Pub.dev Ecosystem',
    badge: 'Open Source',
    description:
        'Creating reusable packages for PDF reading, offline REST sync, image classification, calendars, augmented reality and responsive UI development.',
  ),
];

const projectItems = <ProjectItem>[
  ProjectItem(
    type: 'Enterprise ERP',
    status: 'Published on Google Play',
    title: 'ExpressERP',
    description:
        'An enterprise mobile ERP application for PRAN-RFL Group that connects Oracle EBS and ORDS workflows across production, inventory, quality, sample collection, market operations, QR processing and business reporting.',
    tech: ['Flutter', 'BLoC / Cubit', 'Oracle EBS', 'Oracle ORDS', 'PL/SQL'],
    links: [
      ProjectLink('GitHub ↗', 'https://github.com/NafimAhmed/pran-erp'),
      ProjectLink(
        'Google Play ↗',
        'https://play.google.com/store/apps/details?id=com.pranrfl.express_erp&pcampaignid=web_share',
        kind: 'store',
      ),
    ],
  ),
  ProjectItem(
    type: 'Cross-platform ERP',
    status: 'Android & iOS',
    title: 'Cripton Pro',
    description:
        'A cross-platform ERP mobile application designed to simplify business operations, provide secure access to organizational data and support structured workflow management on Android and iOS.',
    tech: ['Flutter', 'Dart', 'REST API', 'ERP', 'Store Deployment'],
    links: [
      ProjectLink('GitHub ↗', 'https://github.com/NafimAhmed/cripton-erp'),
      ProjectLink(
        'Google Play ↗',
        'https://play.google.com/store/apps/details?id=com.worknestor.criptonpro&pcampaignid=web_share',
        kind: 'store',
      ),
      ProjectLink(
        'App Store ↗',
        'https://apps.apple.com/us/app/cripton-erp/id6478108512',
        kind: 'appStore',
      ),
    ],
  ),
  ProjectItem(
    type: 'E-commerce',
    status: 'Published on iOS',
    title: 'Enorsia',
    description:
        'A European e-commerce mobile application with product discovery, account management, API-driven catalog content and a scalable Flutter architecture designed for a smooth shopping experience.',
    tech: ['Flutter', 'E-commerce', 'REST API', 'iOS Deployment'],
    links: [
      ProjectLink(
        'GitHub ↗',
        'https://github.com/NafimAhmed/enorsia-e-commerce',
      ),
      ProjectLink(
        'App Store ↗',
        'https://apps.apple.com/cn/app/enorsia/id6470290654',
        kind: 'appStore',
      ),
    ],
  ),
  ProjectItem(
    type: 'AI Automation',
    status: 'AI Project',
    title: 'AI Interview Agent for Google Meet',
    description:
        'An AI-assisted interview-agent project created around Google Meet to explore automated interview workflows, intelligent question handling and structured candidate-interaction experiences.',
    tech: ['Artificial Intelligence', 'Python', 'Automation', 'Google Meet'],
    links: [
      ProjectLink(
        'View GitHub ↗',
        'https://github.com/NafimAhmed/google-meet-interview-agent',
      ),
    ],
  ),
  ProjectItem(
    type: 'AI + Oracle EBS',
    status: 'Forecasting Project',
    title: 'Product Demand Forecasting for Oracle EBS',
    description:
        'A machine-learning project that connects enterprise product data with a demand-forecasting workflow to explore how predictive analytics can support inventory and planning decisions around Oracle EBS.',
    tech: [
      'Python',
      'Machine Learning',
      'Forecasting',
      'Oracle EBS',
      'Data Analysis',
    ],
    links: [
      ProjectLink(
        'View GitHub ↗',
        'https://github.com/NafimAhmed/oracle-ebs-connection-product-demand-forecasting',
      ),
    ],
  ),
  ProjectItem(
    type: 'Real-time Communication',
    status: 'Backend Project',
    title: 'Telegram Messaging Automation Platform',
    description:
        'A Telegram-based messaging and automation project focused on bot integration, programmatic communication and a backend foundation for connecting Telegram workflows with client applications.',
    tech: ['Python', 'Telegram API', 'Bot Automation', 'Backend'],
    links: [
      ProjectLink(
        'View GitHub ↗',
        'https://github.com/NafimAhmed/telegram-bot2',
      ),
    ],
  ),
];

const packageItems = <PackageItem>[
  PackageItem(
    icon: 'PDF',
    title: 'ai_pdf_reader',
    description:
        'PDF text extraction, text-to-speech, highlighting, reading position and controller-based document reading.',
    url: 'https://pub.dev/packages/ai_pdf_reader',
  ),
  PackageItem(
    icon: 'SYNC',
    title: 'easy_rest_sync',
    description:
        'Offline-first REST synchronization for Flutter with local persistence, streaming and conflict-ready application workflows.',
    url: 'https://pub.dev/packages/easy_rest_sync',
  ),
  PackageItem(
    icon: 'AI',
    title: 'flutter_tflite_image_classification_engine',
    description:
        'Flexible TFLite image and frame classification engine with configurable preprocessing and real-time stream support.',
    url:
        'https://pub.dev/packages/flutter_tflite_image_classification_engine',
  ),
  PackageItem(
    icon: 'MP',
    title: 'mediapipeline_flutter',
    description:
        'MediaPipe-powered Flutter vision pipelines with native Android hand landmark detection and basic gesture recognition.',
    url: 'https://pub.dev/packages/mediapipeline_flutter',
  ),
  PackageItem(
    icon: 'FCM',
    title: 'firebase_notification_helper',
    description:
        'Helper utilities for Firebase Messaging, local notifications, tokens, topics and trusted-server push notification workflows.',
    url: 'https://pub.dev/packages/firebase_notification_helper',
  ),
  PackageItem(
    icon: 'CAL',
    title: 'linear_calender',
    description:
        'Customizable linear calendar widget with flexible dates, selection, sizing, borders, styles and behavior.',
    url: 'https://pub.dev/packages/linear_calender',
  ),
  PackageItem(
    icon: 'AR',
    title: 'ar_tryon_view',
    description:
        'Augmented-reality try-on component designed for interactive camera, face-mask, glasses and transparent overlay experiences.',
    url: 'https://pub.dev/packages/ar_tryon_view',
  ),
  PackageItem(
    icon: 'UI',
    title: 'absolute_sizer',
    description:
        'Responsive sizing utility for building consistent Flutter interfaces across different screen dimensions.',
    url: 'https://pub.dev/packages/absolute_sizer',
  ),
];

const publicationItems = <PublicationItem>[
  PublicationItem(
    year: '2022',
    title: 'Traffic Flow Forecasting in Intelligent Transportation Systems',
    description:
        'IEEE publication focused on data-driven traffic analysis and forecasting within intelligent transportation environments.',
    url: 'https://ieeexplore.ieee.org/document/10094319/references#references',
    linkLabel: 'View IEEE Publication ↗',
  ),
  PublicationItem(
    year: '2023',
    title: 'Bucket Filling Algorithm',
    description:
        'Research publication in Asian Social Science Research presenting an algorithmic approach to structured bucket-filling problems.',
    url: 'http://asianssr.org/index.php/ajct/article/view/1275/948',
    linkLabel: 'View Journal Publication ↗',
  ),
];
