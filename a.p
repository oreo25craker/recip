import pandas as pd
import mysql.connector

# 1. CSV 파일 열기
csv_file_path = '/mnt/data/TB_RECIPE_SEARCH-220701.csv'
data = pd.read_csv(csv_file_path)

# 데이터 확인 (첫 5행 출력)
print(data.head())

# 2. MySQL 데이터베이스에 연결
db = mysql.connector.connect(
    host="localhost",
    user="your_username",         # MySQL 사용자 이름
    password="your_password",     # MySQL 비밀번호
    database="example_db"         # 사용하려는 데이터베이스 이름
)

# MySQL 커서 생성
cursor = db.cursor()

# 3. 테이블 생성하기 (테이블 구조는 CSV 파일의 컬럼에 맞춰 작성)
table_name = "recipe_data"
create_table_query = f"""
CREATE TABLE IF NOT EXISTS {table_name} (
    recipe_id INT PRIMARY KEY,
    recipe_name VARCHAR(255),
    ingredients TEXT,
    instructions TEXT,
    prep_time INT,
    cook_time INT
    -- 필요에 따라 추가 컬럼 정의
);
"""
cursor.execute(create_table_query)

# 4. 데이터 삽입
for _, row in data.iterrows():
    insert_query = f"""
    INSERT INTO {table_name} (recipe_id, recipe_name, ingredients, instructions, prep_time, cook_time)
    VALUES (%s, %s, %s, %s, %s, %s)
    """
    values = (row['recipe_id'], row['recipe_name'], row['ingredients'], row['instructions'], row['prep_time'], row['cook_time'])
    cursor.execute(insert_query, values)

# 변경 사항 커밋
db.commit()

# 연결 닫기
cursor.close()
db.close()

print("Data inserted successfully!")
