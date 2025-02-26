import cx_Oracle
cx_Oracle.init_oracle_client(lib_dir=r"D:\Programs\oracle\instantclient_23_5")

host = '172.17.9.65'  
port = 1521
sid = 'xe'
username = 'das22119'
password = 'oracle'

dsn = cx_Oracle.makedsn(host, port, sid=sid)

conn = cx_Oracle.connect(user=username, password=password, dsn=dsn)

def Insert_Image(conn, Property_Id, Photo_Id, Photo_Path):
    cursor = conn.cursor()
    with open(Photo_Path, 'rb') as file:
        image_data = file.read()
    cursor.setinputsizes(Photo=cx_Oracle.BLOB)
    cursor.execute('INSERT INTO Property_Photos  VALUES (:Property_Id, :Photo_Id, :Photo)', {'Property_Id': Property_Id, 'Photo_Id': Photo_Id, 'Photo': image_data})
    conn.commit()
    cursor.close()

def Retrieve_Image(conn, Property_Id, Photo_Id):
    cursor = conn.cursor()
    cursor.execute("Select Photo_Id,Photo from Property_Photos where Property_Id = :Property_Id and Photo_Id = :Photo_Id", [Property_Id, Photo_Id])
    Photo_Id, Photo = cursor.fetchone()
    with open(str(Property_Id)+'_'+str(Photo_Id)+'.jpeg', 'wb') as file:
        file.write(Photo.read())
    cursor.close()
    return file

main_path = 'D:/Property Management System/Frontend/Property Photos/'
image_paths = ["1.jpeg", "2.jpg", "3.jpg", "4.jpg", "5.jpeg", "6.jpeg", "7.jpeg", "8.jpeg", "9.jpeg", "10.jpeg"]

for i in range(1, len(image_paths)):
    Insert_Image(conn, i, 1, main_path+image_paths[i])

img = Retrieve_Image(conn, 3, 1)

conn.close()

print("Images uploaded successfully!")