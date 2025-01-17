from keras.applications import ResNet50, InceptionV3, MobileNetV2, VGG16
from keras.models import Model
from keras.layers import Dense, GlobalAveragePooling2D
from keras.preprocessing.image import ImageDataGenerator
from keras.optimizers import Adam

# 데이터 경로 설정
train_dir = r"C:\Users\dkdle\Desktop\archive\Train_Test_Valid\Train"
val_dir = r"C:\Users\dkdle\Desktop\archive\Train_Test_Valid\valid"
batch_size = 32
input_shape = (224, 224, 3)

# 데이터 로더 (증강 제거, 단순 리스케일)
data_gen = ImageDataGenerator(rescale=1./255)

train_generator = data_gen.flow_from_directory(
    train_dir,
    target_size=(224, 224),
    batch_size=batch_size,
    class_mode='categorical'
)

val_generator = data_gen.flow_from_directory(
    val_dir,
    target_size=(224, 224),
    batch_size=batch_size,
    class_mode='categorical'
)

# 모델 생성 함수
def create_model(base_model, num_classes):
    x = base_model.output
    x = GlobalAveragePooling2D()(x)
    outputs = Dense(num_classes, activation='softmax')(x)
    return Model(inputs=base_model.input, outputs=outputs)

# 간단한 학습 루프
for model_name, base_model_class in [
    ("VGG16", VGG16),
    ("ResNet50", ResNet50),
    ("InceptionV3", InceptionV3),
    ("MobileNetV2", MobileNetV2)
]:
    print(f"Training {model_name}...")

    # 베이스 모델 로드
    base_model = base_model_class(weights='imagenet', include_top=False, input_shape=input_shape)
    base_model.trainable = False

    # 모델 생성
    model = create_model(base_model, num_classes=train_generator.num_classes)
    model.compile(optimizer=Adam(learning_rate=0.001), loss='categorical_crossentropy', metrics=['accuracy'])

    # 모델 학습
    model.fit(
        train_generator,
        validation_data=val_generator,
        epochs=15,  # 기본적으로 3 에포크만 실행
        verbose=1
    )

    # 학습된 모델 저장
    model.save(f"{model_name}_basic_model.h5")
    print(f"{model_name} model saved!")
