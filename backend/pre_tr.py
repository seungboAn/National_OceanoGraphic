from keras.applications import ResNet50, InceptionV3, MobileNetV2,VGG16
from keras.models import Sequential, Model
from keras.layers import Dense, Dropout, GlobalAveragePooling2D
from keras.preprocessing.image import ImageDataGenerator
from keras.optimizers import Adam

# 데이터 경로 설정
train_dir = r"C:\Users\dkdle\Desktop\archive\Train_Test_Valid\Train"
val_dir = r"C:\Users\dkdle\Desktop\archive\Train_Test_Valid\valid"
batch_size = 32
input_shape = (224, 224, 3)  # ResNet, Inception, MobileNet 모두 기본적으로 224x224x3 입력 사용

# 데이터 증강
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    horizontal_flip=True
)
val_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow_from_directory(
    train_dir,
    target_size=(224, 224),
    batch_size=batch_size,
    class_mode='categorical'
)

val_generator = val_datagen.flow_from_directory(
    val_dir,
    target_size=(224, 224),
    batch_size=batch_size,
    class_mode='categorical'
)

# 모델 생성 함수
def create_model(base_model, num_classes):
    # 사전 학습된 모델의 출력 가져오기
    x = base_model.output
    x = GlobalAveragePooling2D()(x)
    x = Dense(256, activation='relu')(x)
    x = Dropout(0.5)(x)
    outputs = Dense(num_classes, activation='softmax')(x)
    return Model(inputs=base_model.input, outputs=outputs)

# 모델별 추가 학습
for model_name, base_model_class in [
    ("VGG16", VGG16),
    # ("ResNet50", ResNet50),
    # ("InceptionV3", InceptionV3),
    # ("MobileNetV2", MobileNetV2)
]:
    print(f"Training {model_name}...")
    
    # 베이스 모델 로드
    base_model = base_model_class(weights='imagenet', include_top=False, input_shape=input_shape)
    base_model.trainable = False  # 사전 학습된 가중치를 고정

    # 모델 생성
    model = create_model(base_model, num_classes=train_generator.num_classes)
    model.compile(optimizer=Adam(learning_rate=0.001), loss='categorical_crossentropy', metrics=['accuracy'])

    # 모델 학습
    model.fit(
        train_generator,
        validation_data=val_generator,
        epochs=10,
        batch_size=batch_size,
        verbose=1
    )

    # 학습된 모델 저장
    model.save(f"{model_name}_jellyfish_model.h5")
    print(f"{model_name} model saved!")
