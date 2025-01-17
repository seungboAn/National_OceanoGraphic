import os
from keras.models import load_model
from keras.preprocessing.image import ImageDataGenerator

# 경로 설정
model_path = r"C:\Users\dkdle\Desktop\archive\jellyfish_vgg16_model.h5"
test_dir = r"C:\Users\dkdle\Desktop\archive\Train_Test_Valid\test"

# 모델 로드
model = load_model(model_path)
print("Model loaded successfully!")
model.summary()  # 모델 구조 출력

# 테스트 데이터 준비
# 모델의 입력 크기를 확인 후, 아래 target_size를 수정하세요.
test_datagen = ImageDataGenerator(rescale=1./255)
test_generator = test_datagen.flow_from_directory(
    test_dir,
    target_size=(224, 224),  # 모델 입력 크기와 동일하게 수정
    batch_size=32,
    class_mode='categorical',
    shuffle=False
)

# 모델 평가
loss, accuracy = model.evaluate(test_generator)
print(f"Test Accuracy: {accuracy * 100:.2f}%")
print(f"Test Loss: {loss:.4f}")
