import os
from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout, BatchNormalization


base_dir = r'C:\Users\dkdle\Desktop\archive\Train_Test_Valid'
train_dir = os.path.join(base_dir, 'train')
val_dir = os.path.join(base_dir, 'valid')

print("Base directory:", os.path.exists(base_dir))
print("Train directory:", os.path.exists(train_dir))
print("Validation directory:", os.path.exists(val_dir))

 #데이터 증강
datagen = ImageDataGenerator(
    rescale=1./255,  # 정규화
    rotation_range=20,  # 이미지 회전
    width_shift_range=0.2,  # 가로 방향 이동
    height_shift_range=0.2,  # 세로 방향 이동
    horizontal_flip=True  # 좌우 반전
)

# 데이터 로더
train_generator = datagen.flow_from_directory(
    train_dir,
    target_size=(128, 128),  # 이미지 크기 조정
    batch_size=32,
    class_mode='categorical'  # 다중 클래스 분류
)

val_generator = datagen.flow_from_directory(
    val_dir,
    target_size=(128, 128),
    batch_size=32,
    class_mode='categorical'
)

# CNN 모델 정의
def create_base_model(input_shape, num_classes):
    model = Sequential()
    
    # Conv Layer 1
    model.add(Conv2D(32, (3, 3), activation='relu', input_shape=input_shape))
    model.add(BatchNormalization())
    model.add(MaxPooling2D(pool_size=(2, 2)))
    
    # Conv Layer 2
    model.add(Conv2D(64, (3, 3), activation='relu'))
    model.add(BatchNormalization())
    model.add(MaxPooling2D(pool_size=(2, 2)))
    
    # Conv Layer 3
    model.add(Conv2D(128, (3, 3), activation='relu'))
    model.add(BatchNormalization())
    model.add(MaxPooling2D(pool_size=(2, 2)))
    
    # Flatten & Fully Connected Layer
    model.add(Flatten())
    model.add(Dense(128, activation='relu'))
    model.add(Dropout(0.5))  # Dropout for regularization
    model.add(Dense(num_classes, activation='softmax'))  # Output Layer
    
    model.compile(optimizer='adam', 
                  loss='categorical_crossentropy', 
                  metrics=['accuracy'])
    return model

# 모델 생성
input_shape = (128, 128, 3)
num_classes = train_generator.num_classes
model = create_base_model(input_shape, num_classes)

model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=10
)