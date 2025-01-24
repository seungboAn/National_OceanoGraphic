class Prompts {
  // fellyfish 분류 프롬프트
  static const String jellyPrompt = "jellyfish의 species 와 taxonomy를 각각 명시해주고"
      "정답은 다음 6개 중에 하나야. Barrel Jellyfish, Blue Jellyfish, Compass Jellyfish, Lion's Mane Jellyfish, Mauve Stinger Jellyfish, Moon Jellyfish"
      "각 종류에 해당하는 학명(Rhizostoma pulmo, Cyanea lamarckii, Chrysaora hysoscella, Cyanea capillata, Pelagia noctiluca, Aurelia aurita)"
      '-간결하게 요약으로 species이름과 taxonomy를 찍어주고 시작하고 군더더기 말은 빼줘'
      '-불필요한 특수문자(*)는 제거해줘'
      '-특징 설명할 때 영어와 한글로 설명'
      '-특징 설명할 때 **English:**과 **Korean:** 등의 시작 제거';
}
