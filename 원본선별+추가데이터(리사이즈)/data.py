import os
from PIL import Image

# 원본 이미지가 저장된 디렉토리와 변환된 이미지를 저장할 디렉토리 설정
input_dir = r"C:\Users\dkdle\Desktop\data2\jellyfish_images\moon_jellyfish"  # 원본 이미지 폴더
output_dir = r"C:\Users\dkdle\Desktop\data2\jellyfish_images\moon_jellyfish_resized"  # 변환된 이미지를 저장할 폴더

# 출력 폴더가 없으면 생성
os.makedirs(output_dir, exist_ok=True)

# 이미지 변환 함수
def resize_images(input_dir, output_dir, size=(224, 224)):
    for filename in os.listdir(input_dir):
        input_path = os.path.join(input_dir, filename)
        
        # 이미지 파일만 처리
        if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif')):
            try:
                # 이미지 열기
                with Image.open(input_path) as img:
                    # 크기 변환
                    img_resized = img.resize(size)
                    # 출력 파일 경로 설정
                    output_path = os.path.join(output_dir, filename)
                    # 변환된 이미지 저장
                    img_resized.save(output_path)
                    print(f"변환 완료: {output_path}")
            except Exception as e:
                print(f"오류 발생: {filename} - {e}")

# 실행
resize_images(input_dir, output_dir)
