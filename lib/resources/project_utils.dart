class ProjectUtils {
  final String image;
  final String title;
  final String subtitle;
  final String? androidLink;
  final String? iosLink;
  final String? webLink;

  ProjectUtils({
    required this.image,
    required this.title,
    required this.subtitle,
    this.androidLink,
    this.iosLink,
    this.webLink,
  });
}

// ###############
// HOBBY PROJECTS
List<ProjectUtils> capstoneProjectUtils = [
  ProjectUtils(
    image: 'assets/image1.png',
    title: 'Garage Booking',
    subtitle:
        'This is a app allows users to easily find and book services at trusted garages and service centers',
    androidLink:
        'https://play.google.com/store/apps/details?id=com.shohatech.eduza',
  ),
  ProjectUtils(
    image: 'assets/image4.png',
    title: 'Elderly Sitter',
    subtitle:
        'This is a comprehensive platform that helps families find and book reliable caregivers for elderly loved ones',
    androidLink:
        'https://play.google.com/store/apps/details?id=com.shohatech.eduza_eng_dictionary',
    iosLink:
        "https://apps.apple.com/us/app/eduza-english-dictionary/id6443770339",
  ),
  // ProjectUtils(
  //     image: 'assets/image1.png',
  //     title: 'Pocket Dictionary',
  //     subtitle:
  //         'This is a word memorising app to save and play your own words as quizes',
  //     androidLink:
  //         'https://play.google.com/store/apps/details?id=com.shohruhak.eng_pocket_dictionary',
  //     iosLink:
  //         'https://apps.apple.com/tr/app/pocket-dictionary-1/id6447465115'),
  // ProjectUtils(
  //   image: 'assets/image1.png',
  //   title: 'Tasbeeh Counter',
  //   subtitle:
  //       'This is a simple dzikr counter app for muslims with persistent storage',
  //   androidLink:
  //       'https://play.google.com/store/apps/details?id=com.shohatech.tasbeeh',
  // ),
  // ProjectUtils(
  //   image: 'assets/image1.png',
  //   title: 'Todo App',
  //   subtitle: 'This is a simple task management app with persistent storage',
  //   androidLink:
  //       'https://play.google.com/store/apps/details?id=com.shohatech.todo',
  //   iosLink: "https://apps.apple.com/us/app/eduza-todo/id6443970333",
  // ),
  // ProjectUtils(
  //   image: 'assets/image1.png',
  //   title: 'NotePad App',
  //   subtitle: 'This is a note taking app for MacOS and Android',
  //   androidLink:
  //       'https://play.google.com/store/apps/details?id=com.shohatech.notepad',
  //   iosLink: 'https://apps.apple.com/us/app/eduza-notepad/id6443973859',
  // ),
];

// ###############
// WORK PROJECTS
List<ProjectUtils> workProjectUtils = [
  ProjectUtils(
    image: 'assets/image2.png',
    title: 'WIZMO',
    subtitle:
        'This is a comprehensive tool designed to help users keep track of their finances. With this app, users can easily monitor their income and expenses, set budgets...',
    androidLink:
        'https://play.google.com/store/apps/details?id=kr.co.evolcano.donotstudy',
    iosLink:
        "https://apps.apple.com/kr/app/%EC%98%81%EC%96%B4%EB%A8%B8%EB%A6%AC-%EA%B3%B5%EC%9E%91%EC%86%8C/id1507102714",
  ),
  ProjectUtils(
    image: 'assets/image3.png',
    title: 'VIPA English App',
    subtitle:
        'This is an innovative tool designed to help users enhance their pronunciation skills by many games.',
    webLink: 'https://www.elo.best',
  ),
  ProjectUtils(
    image: 'assets/image5.png',
    title: 'Lango',
    subtitle:
        'This project aims to enhance users initiative in learning foreign languages through the process of exploring life, making learning more interesting',
    webLink: 'https://www.externally.unavailable.project',
  ),
];
