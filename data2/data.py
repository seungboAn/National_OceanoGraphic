import os
import time
import urllib.request
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from PIL import Image
from io import BytesIO

# 해파리 종류 목록
jellyfish_types = ["barrel jellyfish", "blue jellyfish", "compass jellyfish",
                   "lions mane jellyfish", "mauve stinger jellyfish", "moon jellyfish"]

# 최상위 저장 폴더
save_dir = "jellyfish_images"
os.makedirs(save_dir, exist_ok=True)

# Selenium WebDriver 설정
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))

# 이미지 다운로드 및 크기 변환 함수
def download_and_resize_images(query, max_images=300, width=244, height=244, delay=2):
    print(f"Scraping images for: live {query}")
    
    # Google Images URL
    url = f"https://www.google.com/search?tbm=isch&q=live+{query.replace(' ', '+')}"
    driver.get(url)
    time.sleep(2)
    
    # 스크롤을 통해 이미지 더 로드
    for _ in range(10):  # 스크롤 10번 (300장 확보를 위해 추가 스크롤)
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(2)
    
    # 이미지 태그 가져오기
    images = driver.find_elements(By.CSS_SELECTOR, "img")
    
    # 저장 폴더 생성
    query_dir = os.path.join(save_dir, query.replace(" ", "_"))
    os.makedirs(query_dir, exist_ok=True)
    
    count = 0
    for img in images:
        if count >= max_images:
            break
        try:
            # 이미지 URL 가져오기
            img_url = img.get_attribute("src")
            if img_url and img_url.startswith("http"):
                # 원본 이미지 다운로드
                response = urllib.request.urlopen(img_url)
                img_data = response.read()
                img = Image.open(BytesIO(img_data))
                
                # 이미지 크기 변환
                resized_img = img.resize((width, height))
                
                # 저장
                file_path = os.path.join(query_dir, f"{query.replace(' ', '_')}_{count}.jpg")
                resized_img.save(file_path, "JPEG")
                print(f"Saved resized image: {file_path}")
                count += 1
                time.sleep(delay)  # 요청 간 딜레이 추가
        except Exception as e:
            print(f"Failed to download or resize image: {e}")

# 종류별 이미지 다운로드 실행
for jellyfish in jellyfish_types:
    download_and_resize_images(jellyfish, max_images=300, width=244, height=244, delay=2)

# 브라우저 종료
driver.quit()
