import os
import shutil
from tensorflow.keras.preprocessing.image import ImageDataGenerator, load_img, img_to_array

# 원본 데이터셋 경로
base_path = './dataset/'
dataset = "3_classweight80"
dataset_path = os.path.join(base_path, dataset)

# 유효한 클래스 확인
valid_classes = [d for d in os.listdir(dataset_path) if os.path.isdir(os.path.join(dataset_path, d)) and d != '.ipynb_checkpoints']

# 데이터 증강 설정
data_gen = ImageDataGenerator(
    rotation_range=20,
    zoom_range=0.1,
    shear_range=0.1,
    horizontal_flip=True,
    height_shift_range=0,
    width_shift_range=0.1
)

# 각 클래스별로 이미지 증강 및 저장
for class_name in valid_classes:
    class_path = os.path.join(dataset_path, class_name)
    save_path = os.path.join(dataset_path + '_augmented', class_name)

    if not os.path.exists(save_path):
        os.makedirs(save_path)

    for img_name in os.listdir(class_path):
        img_path = os.path.join(class_path, img_name)
        
        # 원본 이미지 복사
        shutil.copy(img_path, save_path)
        
        img = load_img(img_path)
        x = img_to_array(img)
        x = x.reshape((1,) + x.shape)

        i = 0
        for batch in data_gen.flow(x, batch_size=1, save_to_dir=save_path, save_prefix='aug', save_format='jpg'):
            i += 1
            if i > 4:  # 각 이미지당 4개의 증강된 이미지 생성 (원본 포함 총 5개)
                break

print("데이터 증강 및 저장 완료!")
