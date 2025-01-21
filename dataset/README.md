# National_OceanoGraphic

## Jelly FISH 데이터셋에 관하여 설명 드립니다


### 1_kaggle
캐글에 있는 원본 데이터 셋입니다. 원본이미지 4~50장사이에 증강으로 150장 맞춰줘 있습니다

### 2_quality_sort
캐글에 있는 원본 데이터 셋에서 증강부분과 관련없는 이미지 부분을 제외한 데이터 셋입니다
각 클래스별로 남아있는 사진은 아래와 같습니다.
barrel:30
blue:8
compass:41
lion:54
mauve:48
moon:41

### 3_classweight80
2_quality_sort 데이터셋에 따로 이미지 데이터를 추가적으로 모아 균형을 맞춘 데이터 셋 입니다
가장 적은 수의 클래스는 blue_jellyfish의 80장이며 나머지는 그 이상 모여있습니다.
blue_jellyfish의 절대적인 데이터양이 부족하여 우선 80장을 기준으로 이름지었습니다.