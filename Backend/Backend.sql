BEGIN
   FOR t IN (SELECT table_name FROM user_tables) 
   LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;
END;
/

CREATE TABLE Registration_Offices( 
    Reg_Off_Id INT NOT NULL, 
    Office_Name VARCHAR(255) NOT NULL, 
    Office_Address VARCHAR(255) NOT NULL, 
    Phone_No VARCHAR(15) NOT NULL, 
    PRIMARY KEY(Reg_Off_Id)
);

CREATE TABLE Buyer( 
    Buyer_Id VARCHAR(50) NOT NULL, 
    Password VARCHAR(255) NOT NULL, 
    Name VARCHAR(255) NOT NULL, 
    Phone_No VARCHAR(15) NOT NULL, 
    Mail_Id VARCHAR(255) NOT NULL, 
    PRIMARY KEY(Buyer_Id)
);

CREATE TABLE Seller( 
    Seller_Id VARCHAR(50) NOT NULL, 
    Password VARCHAR(255) NOT NULL, 
    Name VARCHAR(255) NOT NULL, 
    Phone_No VARCHAR(15) NOT NULL, 
    Mail_Id VARCHAR(255) NOT NULL, 
    PRIMARY KEY(Seller_Id)
);

CREATE TABLE Admin( 
    Admin_Id VARCHAR(50) NOT NULL, 
    Password VARCHAR(255) NOT NULL, 
    Name VARCHAR(255) NOT NULL, 
    Phone_No VARCHAR(15) NOT NULL, 
    Mail_Id VARCHAR(255) NOT NULL, 
    PRIMARY KEY(Admin_Id)
);  

CREATE TABLE Property( 
    Property_Id INT NOT NULL, 
    Address VARCHAR(255) NOT NULL, 
    Type VARCHAR(255) NOT NULL, 
    Listing_Title VARCHAR(255) NOT NULL, 
    Listing_Type VARCHAR(255) NOT NULL, 
    Listing_Description VARCHAR(255) NOT NULL, 
    Listing_Price INT NOT NULL, 
    Seller_Id VARCHAR(50) NOT NULL, 
    Verification_Id INT NOT NULL, 
    PRIMARY KEY(Property_Id),
    FOREIGN KEY(Seller_Id) REFERENCES Seller(Seller_Id)
);

CREATE TABLE Property_Photos( 
    Property_Id INT NOT NULL, 
    Photo_Id INT NOT NULL,
    Photo BLOB NOT NULL, 
    PRIMARY KEY(Property_Id, Photo_Id),
    FOREIGN KEY(Property_Id) REFERENCES Property(Property_Id)
);

CREATE TABLE Govt_Verification( 
    Verification_Id INT NOT NULL, 
    Property_Id INT NOT NULL, 
    Verification_Status NUMBER(1) NOT NULL, 
    Verification_Date DATE, 
    Proof_Of_Ownership BLOB NOT NULL, 
    PRIMARY KEY(Verification_Id),
    FOREIGN KEY(Property_Id) REFERENCES Property(Property_Id)
);

CREATE TABLE Enquiry( 
    Enquiry_Id INT NOT NULL, 
    Buyer_Id VARCHAR(255) NOT NULL, 
    Seller_Id VARCHAR(255) NOT NULL, 
    Property_Id INT NOT NULL, 
    Admin_Id VARCHAR(255) NOT NULL, 
    Final_Amount INT NOT NULL, 
    PRIMARY KEY(Enquiry_Id),
    FOREIGN KEY(Admin_Id) REFERENCES Admin(Admin_Id), 
    FOREIGN KEY(Buyer_Id) REFERENCES Buyer(Buyer_Id), 
    FOREIGN KEY(Seller_Id) REFERENCES Seller(Seller_Id), 
    FOREIGN KEY(Property_Id) REFERENCES Property(Property_Id)
);

CREATE TABLE Conversations( 
    Enquiry_Id INT NOT NULL, 
    Message_Id INT NOT NULL, 
    Buyer_Id VARCHAR(50),
    Seller_Id VARCHAR(50), 
    Admin_Id VARCHAR(50), 
    Message VARCHAR2(4000) NOT NULL, 
    Time_Stamp TIMESTAMP NOT NULL,
    Sent_By VARCHAR(10) NOT NULL,
    PRIMARY KEY (Enquiry_Id, Message_Id), 
    FOREIGN KEY (Buyer_Id) REFERENCES Buyer(Buyer_Id), 
    FOREIGN KEY (Seller_Id) REFERENCES Seller(Seller_Id), 
    FOREIGN KEY (Admin_Id) REFERENCES Admin(Admin_Id)
);

CREATE TABLE Feedback( 
    Feedback_Id INT NOT NULL, 
    Enquiry_Id INT NOT NULL, 
    Feedback VARCHAR(255) NOT NULL, 
    Rating INT NOT NULL CHECK(Rating BETWEEN 1 and 5),
    PRIMARY KEY(Feedback_Id),
    FOREIGN KEY(Enquiry_Id) REFERENCES Enquiry(Enquiry_Id)
);
 
CREATE TABLE Payment( 
    Payment_Id INT NOT NULL, 
    Enquiry_Id INT NOT NULL, 
    Payment_Mode VARCHAR(255) NOT NULL, 
    Transaction_Id VARCHAR(255) NOT NULL, 
    PRIMARY KEY(Payment_Id),
    FOREIGN KEY(Enquiry_Id) REFERENCES Enquiry(Enquiry_Id)
);

CREATE TABLE Registrations( 
    Registration_Id INT NOT NULL, 
    Payment_Id INT NOT NULL, 
    Reg_Off_Id INT NOT NULL, 
    Document_Number VARCHAR(255) NOT NULL, 
    PRIMARY KEY(Registration_Id), 
    FOREIGN KEY(Reg_Off_Id) REFERENCES Registration_Offices(Reg_Off_Id), 
    FOREIGN KEY(Payment_Id) REFERENCES Payment(Payment_Id)
); 


INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (1, 'Office of the Sub-Registrar - Ariyalur', '123, Main Street, Andimadam, Ariyalur, Tamil Nadu', '9876543210');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (2, 'Office of the Sub-Registrar - Chengalpattu', '456, Oak Avenue, Tambaram, Chengalpattu, Tamil Nadu', '9123456780');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (3, 'Office of the Sub-Registrar - Chennai', '789, Pine Lane, Mylapore, Chennai, Tamil Nadu', '9988776655');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (4, 'Office of the Sub-Registrar - Coimbatore', '321, Maple Road, Pollachi, Coimbatore, Tamil Nadu', '8765432109');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (5, 'Office of the Sub-Registrar - Cuddalore', '654, Birch Street, Kattumannarkoil, Cuddalore, Tamil Nadu', '9898989898');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (6, 'Office of the Sub-Registrar - Dharmapuri', '234, Elm Avenue, Dharmapuri, Tamil Nadu', '9955123456');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (7, 'Office of the Sub-Registrar - Dindigul', '567, Cedar Boulevard, Dindigul East, Dindigul, Tamil Nadu', '9807654321');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (8, 'Office of the Sub-Registrar - Erode', '890, Spruce Circle, Gobichettipalayam, Erode, Tamil Nadu', '9745632180');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (9, 'Office of the Sub-Registrar - Kallakurichi', '135, Fir Lane, Kallakkurichi, Tamil Nadu', '9876123456');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (10, 'Office of the Sub-Registrar - Kancheepuram', '246, Cypress Road, Sriperumbudur, Tamil Nadu', '9765432101');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (11, 'Office of the Sub-Registrar - Kanniyakumari', '357, Poplar Street, Kalkulam, Tamil Nadu', '9638527410');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (12, 'Office of the Sub-Registrar - Karur', '468, Willow Way, Kadavur, Tamil Nadu', '9123456781');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (13, 'Office of the Sub-Registrar - Krishnagiri', '579, Oak Road, Hosur, Tamil Nadu', '8901234567');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (14, 'Office of the Sub-Registrar - Madurai', '680, Chestnut Lane, Madurai East, Tamil Nadu', '8762345678');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (15, 'Office of the Sub-Registrar - Namakkal', '791, Beech Street, Namakkal, Tamil Nadu', '9632145789');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (16, 'Office of the Sub-Registrar - Pudukkottai', '802, Walnut Avenue, Alangudi, Tamil Nadu', '9513578624');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (17, 'Office of the Sub-Registrar - Ramanathapuram', '913, Ash Tree Road, Paramakudi, Tamil Nadu', '9081726354');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (18, 'Office of the Sub-Registrar - Salem', '024, Pine Road, Salem, Tamil Nadu', '9201726345');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (19, 'Office of the Sub-Registrar - Thanjavur', '135, Fir Street, Kumbakonam, Tamil Nadu', '9345678901');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (20, 'Office of the Sub-Registrar - Tirunelveli', '246, Maple Lane, Tirunelveli, Tamil Nadu', '9654321789');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (21, 'Office of the Sub-Registrar - Vellore', '357, Birch Avenue, Vellore, Tamil Nadu', '9321456789');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (22, 'Office of the Sub-Registrar - Kodaikanal', '468, Cherry Lane, Kodaikanal, Tamil Nadu', '9654321876');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (23, 'Office of the Sub-Registrar - Thoothukudi', '579, Lemon Avenue, Thoothukudi, Tamil Nadu', '9732184650');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (24, 'Office of the Sub-Registrar - Tenkasi', '680, Ginger Road, Tenkasi, Tamil Nadu', '9487653120');
INSERT INTO Registration_Offices (Reg_Off_Id, Office_Name, Office_Address, Phone_No) VALUES (25, 'Office of the Sub-Registrar - Sivagangai', '791, Coconut Street, Sivagangai, Tamil Nadu', '9856321470');


INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Amit_Kumar_1985', 'Password1!', 'Amit Kumar', '9876543210', 'amit.kumar1985@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Priya_Singh_1990', 'Password2', 'Priya Singh', '9123456780', 'priya.singh1990@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Rahul_Verma_1988', 'Password3!', 'Rahul Verma', '9988776655', 'rahul.verma1988@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Sneha_Mishra_1992', 'Password4!', 'Sneha Mishra', '8765432109', 'sneha.mishra1992@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Vikram_Sharma_1987', 'Password5!', 'Vikram Sharma', '9898989898', 'vikram.sharma1987@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Neha_Rani_1995', 'Password6!', 'Neha Rani', '9955123456', 'neha.rani1995@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Rahul_Agarwal_1993', 'Password7!', 'Rahul Agarwal', '9807654321', 'rahul.agarwal1993@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Sita_Malhotra_1984', 'Password8!', 'Sita Malhotra', '9745632180', 'sita.malhotra1984@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Ajay_Patel_1991', 'Password9!', 'Ajay Patel', '9876123456', 'ajay.patel1991@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Kavita_Desai_1989', 'Password10!', 'Kavita Desai', '9765432101', 'kavita.desai1989@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Ravi_Sharma_1986', 'Password11!', 'Ravi Sharma', '9888654321', 'ravi.sharma1986@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Anjali_Kumar_1994', 'Password12!', 'Anjali Kumar', '9749812365', 'anjali.kumar1994@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Suresh_Nath_1982', 'Password13!', 'Suresh Nath', '9812365478', 'suresh.nath1982@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Pooja_Jain_1990', 'Password14!', 'Pooja Jain', '9723465213', 'pooja.jain1990@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Manish_Gupta_1983', 'Password15!', 'Manish Gupta', '9900246813', 'manish.gupta1983@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Aishwarya_Rao_1995', 'Password16!', 'Aishwarya Rao', '9983641285', 'aishwarya.rao1995@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Vijay_Khan_1988', 'Password17!', 'Vijay Khan', '9834125746', 'vijay.khan1988@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Nisha_Sharma_1991', 'Password18!', 'Nisha Sharma', '9712468321', 'nisha.sharma1991@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Sunil_Singh_1990', 'Password19!', 'Sunil Singh', '9873456721', 'sunil.singh1990@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Nitin_Tiwari_1985', 'Password20!', 'Nitin Tiwari', '9404567890', 'nitin.tiwari1985@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Devika_Rao_1989', 'Password21!', 'Devika Rao', '9823345678', 'devika.rao1989@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Rajesh_Sood_1987', 'Password22!', 'Rajesh Sood', '9781254765', 'rajesh.sood1987@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Shivani_Ghosh_1993', 'Password23!', 'Shivani Ghosh', '9800468756', 'shivani.ghosh1993@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Saurav_Bose_1991', 'Password24!', 'Saurav Bose', '9871356248', 'saurav.bose1991@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Alok_Singh_1994', 'Password25!', 'Alok Singh', '9746891352', 'alok.singh1994@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Meera_Malhotra_1985', 'Password26!', 'Meera Malhotra', '9601023456', 'meera.malhotra1985@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Pavan_Kumar_1986', 'Password27!', 'Pavan Kumar', '9123345678', 'pavan.kumar1986@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Sakshi_Jain_1989', 'Password28!', 'Sakshi Jain', '9087123456', 'sakshi.jain1989@example.com');
INSERT INTO Buyer (Buyer_Id, Password, Name, Phone_No, Mail_Id) VALUES ('Aarav_Sharma_1991', 'Password29!', 'Aarav Sharma', '9903214567', 'aarav.sharma1991@example.com');


INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_rohan_patil_1980', 'Password1!', 'Rohan Patil', '9776543210', 'seller.rohan.patil1980@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_sita_ramesh_1983', 'Password2!', 'Sita Ramesh', '9823456780', 'seller.sita.ramesh1983@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_vishal_rao_1982', 'Password3!', 'Vishal Rao', '9898776655', 'seller.vishal.rao1982@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_manoj_verma_1981', 'Password4!', 'Manoj Verma', '8769432109', 'seller.manoj.verma1981@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_rahul_malhotra_1984', 'Password5!', 'Rahul Malhotra', '8928989898', 'seller.rahul.malhotra1984@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_preeti_singh_1985', 'Password6!', 'Preeti Singh', '9965123456', 'seller.preeti.singh1985@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_kavita_jain_1987', 'Password7!', 'Kavita Jain', '9817654321', 'seller.kavita.jain1987@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_ravi_kumar_1988', 'Password8!', 'Ravi Kumar', '9765632180', 'seller.ravi.kumar1988@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_suman_nair_1990', 'Password9!', 'Suman Nair', '9735432101', 'seller.suman.nair1990@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_mohan_iyer_1986', 'Password10!', 'Mohan Iyer', '9945678910', 'seller.mohan.iyer1986@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_sandeep_joshi_1989', 'Password11!', 'Sandeep Joshi', '9712345678', 'seller.sandeep.joshi1989@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_ajay_kumar_1982', 'Password12!', 'Ajay Kumar', '9612345878', 'seller.ajay.kumar1982@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_ravi_singh_1986', 'Password13!', 'Ravi Singh', '9700462513', 'seller.ravi.singh1986@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_rakesh_rao_1988', 'Password14!', 'Rakesh Rao', '9965432175', 'seller.rakesh.rao1988@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_maya_nair_1991', 'Password15!', 'Maya Nair', '9965432175', 'seller.maya.nair1991@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_arun_sinha_1987', 'Password16!', 'Arun Sinha', '9965432175', 'seller.arun.sinha1987@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_geeta_das_1991', 'Password17!', 'Geeta Das', '9965432175', 'seller.geeta.das1991@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_sujata_rao_1985', 'Password18!', 'Sujata Rao', '9965432175', 'seller.sujata.rao1985@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_amit_verma_1989', 'Password19!', 'Amit Verma', '9965432175', 'seller.amit.verma1989@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_kavita_kulkarni_1988', 'Password20!', 'Kavita Kulkarni', '9965432175', 'seller.kavita.kulkarni1988@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_rohit_mehta_1991', 'Password21!', 'Rohit Mehta', '9965432175', 'seller.rohit.mehta1991@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_vivek_kumar_1984', 'Password22!', 'Vivek Kumar', '9965432175', 'seller.vivek.kumar1984@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_sneha_tandon_1987', 'Password23!', 'Sneha Tandon', '9965432175', 'seller.sneha.tandon1987@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_preeti_joshi_1982', 'Password24!', 'Preeti Joshi', '9965432175', 'seller.preeti.joshi1982@example.com');
INSERT INTO Seller (Seller_Id, Password, Name, Phone_No, Mail_Id) VALUES ('seller_arjun_mehta_1995', 'Password25!', 'Arjun Mehta', '9965432175', 'seller.arjun.mehta1997@example.com');


INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_arun_sinha_1987', 'Password1!', 'Arun Sinha', '9845221234', 'admin_arun_sinha_1987@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_geeta_das_1991', 'Password2!', 'Geeta Das', '9445225678', 'admin_geeta_das_1991@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_sujata_rao_1985', 'Password3!', 'Sujata Rao', '9798887654', 'admin_sujata_rao_1985@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_amit_verma_1989', 'Password4!', 'Amit Verma', '9896543212', 'admin_amit_verma_1989@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_manoj_sharma_1983', 'Password5!', 'Manoj Sharma', '9445234578', 'admin_manoj_sharma_1983@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_riya_bhatia_1990', 'Password6!', 'Riya Bhatia', '9897643215', 'admin_riya_bhatia_1990@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_kavita_kulkarni_1988', 'Password7!', 'Kavita Kulkarni', '9481230987', 'admin_kavita_kulkarni_1988@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_ravi_singh_1986', 'Password8!', 'Ravi Singh', '9965229876', 'admin_ravi_singh_1986@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_preeti_joshi_1982', 'Password9!', 'Preeti Joshi', '9445332112', 'admin_preeti_joshi_1982@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_deepak_mishra_1992', 'Password10!', 'Deepak Mishra', '9798123459', 'admin_deepak_mishra_1992@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_vivek_kumar_1984', 'Password11!', 'Vivek Kumar', '9445212310', 'admin_vivek_kumar_1984@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_sneha_tandon_1987', 'Password12!', 'Sneha Tandon', '9481328765', 'admin_sneha_tandon_1987@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_priya_patel_1990', 'Password13!', 'Priya Patel', '9481781234', 'admin_priya_patel_1990@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_rajesh_mehta_1988', 'Password14!', 'Rajesh Mehta', '9798546789', 'admin_rajesh_mehta_1988@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_neha_agrawal_1993', 'Password15!', 'Neha Agrawal', '9798743219', 'admin_neha_agrawal_1993@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_vikas_malhotra_1991', 'Password16!', 'Vikas Malhotra', '9965712356', 'admin_vikas_malhotra_1991@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_rekha_nair_1986', 'Password17!', 'Rekha Nair', '9445872345', 'admin_rekha_nair_1986@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_ankit_banerjee_1985', 'Password18!', 'Ankit Banerjee', '9487652349', 'admin_ankit_banerjee_1985@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_rahul_shah_1989', 'Password19!', 'Rahul Shah', '9481123456', 'admin_rahul_shah_1989@mail.com');
INSERT INTO Admin (Admin_Id, Password, Name, Phone_No, Mail_Id) VALUES ('admin_shalini_prasad_1992', 'Password20!', 'Shalini Prasad', '9798123467', 'admin_shalini_prasad_1992@mail.com');


INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (1, 'Flat 101, Green Hills, Ariyalur, Tamil Nadu', '3 BHK Apartment', 5000000, 'seller_rohan_patil_1980', 'Residential Property', 'For Sale', 'Spacious 3 BHK apartment with modern amenities.', 1);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (2, 'Flat 202, Silver Oaks, Chengalpattu, Tamil Nadu', '2 BHK Apartment', 3500000, 'seller_sita_ramesh_1983', 'Residential Property', 'For Rent', 'Cozy 2 BHK available for rent in a prime location.', 2);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (3, 'Plot 303, Valley View, Chennai, Tamil Nadu', 'Residential Plot', 8000000, 'seller_vishal_rao_1982', 'Plot/Land', 'For Sale', 'Prime residential plot with excellent connectivity.', 3);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (4, 'Office 404, Business Hub, Coimbatore, Tamil Nadu', 'Commercial Office Space', 12000000, 'seller_manoj_verma_1981', 'Commercial Property', 'For Lease', 'Well-designed office space in a bustling business hub.', 4);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (5, 'Villa 505, Sunny Meadows, Cuddalore, Tamil Nadu', '4 BHK Villa', 7000000, 'seller_rahul_malhotra_1984', 'Residential Property', 'For Sale', 'Luxurious 4 BHK villa with garden and parking.', 5);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (6, 'Shop 606, Market Street, Dharmapuri, Tamil Nadu', 'Commercial Shop', 3000000, 'seller_preeti_singh_1985', 'Commercial Property', 'For Rent', 'Strategically located commercial shop in a busy market area.', 6);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (7, 'Land 707, Farm Area, Dindigul, Tamil Nadu', 'Agricultural Land', 4000000, 'seller_kavita_jain_1987', 'Plot/Land', 'For Sale', 'Fertile agricultural land ideal for farming.', 7);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (8, 'Flat 808, Rose Garden, Erode, Tamil Nadu', '2 BHK Apartment', 6000000, 'seller_ravi_kumar_1988', 'Residential Property', 'For Rent', 'Beautiful 2 BHK apartment surrounded by gardens.', 8);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (9, 'Bungalow 909, Hill View, Kallakkurichi, Tamil Nadu', '5 BHK Bungalow', 9500000, 'seller_suman_nair_1990', 'Residential Property', 'For Sale', 'Spacious 5 BHK bungalow with stunning hill views.', 9);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (10, 'Shop 1001, Main Market, Kancheepuram, Tamil Nadu', 'Retail Space', 2000000, 'seller_mohan_iyer_1986', 'Commercial Property', 'For Lease', 'Retail space in a prime shopping area.', 10);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (11, 'Flat 1101, Sunshine Apartments, Cuddalore, Tamil Nadu', '1 BHK Apartment', 2500000, 'seller_sandeep_joshi_1989', 'Residential Property', 'For Sale', 'Affordable 1 BHK apartment in a quiet neighborhood.', 11);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (12, 'Plot 1202, Green Acres, Madurai, Tamil Nadu', 'Residential Plot', 5500000, 'seller_ajay_kumar_1982', 'Plot/Land', 'For Sale', 'Well-located residential plot with easy access to amenities.', 12);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (13, 'Shop 1303, New Market, Namakkal, Tamil Nadu', 'Commercial Space', 4000000, 'seller_ravi_singh_1986', 'Commercial Property', 'For Rent', 'Spacious commercial space available for rent.', 13);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (14, 'Office 1404, Tech Park, Chennai, Tamil Nadu', 'Office Space', 15000000, 'seller_rakesh_rao_1988', 'Commercial Property', 'For Lease', 'Modern office space in a tech park with all facilities.', 14);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (15, 'Villa 1505, Garden View, Tirunelveli, Tamil Nadu', '3 BHK Villa', 6000000, 'seller_maya_nair_1991', 'Residential Property', 'For Sale', 'Charming 3 BHK villa with a beautiful garden.', 15);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (16, 'Flat 1606, Urban Heights, Vellore, Tamil Nadu', '2 BHK Apartment', 3200000, 'seller_arun_sinha_1987', 'Residential Property', 'For Rent', 'Modern 2 BHK apartment in the heart of the city.', 16);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (17, 'Land 1707, Eco Park, Erode, Tamil Nadu', 'Agricultural Land', 4500000, 'seller_geeta_das_1991', 'Plot/Land', 'For Sale', 'Agricultural land located near Eco Park.', 17);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (18, 'Bungalow 1808, Riverside, Dindigul, Tamil Nadu', '4 BHK Bungalow', 9000000, 'seller_sujata_rao_1985', 'Residential Property', 'For Sale', 'Luxury 4 BHK bungalow by the river.', 18);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (19, 'Shop 1909, City Center, Dharmapuri, Tamil Nadu', 'Retail Space', 2500000, 'seller_amit_verma_1989', 'Commercial Property', 'For Lease', 'Retail space in the city center available for lease.', 19);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (20, 'Flat 2010, Heritage Homes, Kancheepuram, Tamil Nadu', '3 BHK Apartment', 4900000, 'seller_kavita_kulkarni_1988', 'Residential Property', 'For Sale', '3 BHK apartment in a heritage-style building.', 20);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (21, 'Office 2111, Business Hub, Ariyalur, Tamil Nadu', 'Corporate Office', 14000000, 'seller_rohit_mehta_1991', 'Commercial Property', 'For Lease', 'Corporate office space in a professional setting.', 21);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (22, 'Flat 2212, Sky High, Chennai, Tamil Nadu', '2 BHK Apartment', 3800000, 'seller_vivek_kumar_1984', 'Residential Property', 'For Rent', 'Stylish 2 BHK apartment with skyline views.', 22);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (23, 'Shop 2313, Mega Mall, Salem, Tamil Nadu', 'Shopping Space', 3000000, 'seller_sneha_tandon_1987', 'Commercial Property', 'For Sale', 'Shopping space available in a mega mall.', 23);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (24, 'Land 2414, Nature Valley, Thanjavur, Tamil Nadu', 'Agricultural Land', 6000000, 'seller_preeti_joshi_1982', 'Plot/Land', 'For Sale', 'Prime agricultural land in Nature Valley.', 24);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (25, 'Villa 2515, Country Side, Tirunelveli, Tamil Nadu', '5 BHK Villa', 8500000, 'seller_sandeep_joshi_1989', 'Residential Property', 'For Sale', 'Luxury 5 BHK villa in a countryside setting.', 25);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (26, 'Flat 2616, New Heights, Chennai, Tamil Nadu', '3 BHK Apartment', 5200000, 'seller_kavita_jain_1987', 'Residential Property', 'For Rent', 'Modern 3 BHK apartment with all amenities.', 26);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (27, 'Bungalow 2717, Hill Crest, Kallakurichi, Tamil Nadu', '4 BHK Bungalow', 9600000, 'seller_rakesh_rao_1988', 'Residential Property', 'For Sale', 'Spacious 4 BHK bungalow with hill views.', 27);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (28, 'Shop 2818, Local Market, Erode, Tamil Nadu', 'Commercial Shop', 3200000, 'seller_sita_ramesh_1983', 'Commercial Property', 'For Rent', 'Commercial shop in a bustling local market.', 28);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (29, 'Flat 2919, Valley View, Madurai, Tamil Nadu', '2 BHK Apartment', 3700000, 'seller_arjun_mehta_1995', 'Residential Property', 'For Sale', 'Charming 2 BHK apartment with valley views.', 29);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (30, 'Plot 3020, Riverbank, Dindigul, Tamil Nadu', 'Residential Plot', 7500000, 'seller_vishal_rao_1982', 'Plot/Land', 'For Sale', 'Beautiful residential plot by the river.', 30);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (31, 'Office 3121, Tech Hub, Chennai, Tamil Nadu', 'Office Space', 15500000, 'seller_preeti_singh_1985', 'Commercial Property', 'For Lease', 'Prime office space in a tech hub.', 31);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (32, 'Villa 3222, Seaside, Tuticorin, Tamil Nadu', '5 BHK Villa', 10200000, 'seller_rahul_malhotra_1984', 'Residential Property', 'For Sale', 'Luxury 5 BHK villa with sea views.', 32);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (33, 'Shop 3323, Central Market, Ariyalur, Tamil Nadu', 'Commercial Shop', 2400000, 'seller_ravi_kumar_1988', 'Commercial Property', 'For Rent', 'Commercial shop in central market area.', 33);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (34, 'Flat 3424, Urban Lifestyle, Chennai, Tamil Nadu', '1 BHK Apartment', 2500000, 'seller_rohan_patil_1980', 'Residential Property', 'For Sale', 'Modern 1 BHK apartment in a vibrant area.', 34);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (35, 'Land 3525, Eco Village, Kallakkurichi, Tamil Nadu', 'Agricultural Land', 4300000, 'seller_rohit_mehta_1991', 'Plot/Land', 'For Sale', 'Agricultural land in Eco Village, ideal for farming.', 35);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (36, 'Bungalow 3626, Hill Side, Thanjavur, Tamil Nadu', '4 BHK Bungalow', 9900000, 'seller_kavita_jain_1987', 'Residential Property', 'For Sale', 'Spacious 4 BHK bungalow with hill views.', 36);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (37, 'Shop 3727, Urban Market, Dharmapuri, Tamil Nadu', 'Retail Space', 2100000, 'seller_preeti_joshi_1982', 'Commercial Property', 'For Lease', 'Retail space in urban market area.', 37);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (38, 'Office 3828, City Plaza, Chennai, Tamil Nadu', 'Corporate Office', 14500000, 'seller_rakesh_rao_1988', 'Commercial Property', 'For Lease', 'Corporate office space in a prime location.', 38);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (39, 'Flat 3929, New Wave, Dindigul, Tamil Nadu', '2 BHK Apartment', 4800000, 'seller_arjun_mehta_1995', 'Residential Property', 'For Rent', 'Stylish 2 BHK apartment available for rent.', 39);
INSERT INTO Property (Property_Id, Address, Listing_Title, Listing_Price, Seller_Id, Type, Listing_Type, Listing_Description, Verification_Id) VALUES (40, 'Land 4030, Green Fields, Cuddalore, Tamil Nadu', 'Residential Plot', 6200000, 'seller_ravi_kumar_1988', 'Plot/Land', 'For Sale', 'Residential plot in a prime location with greenery.', 40);


-- INSERT INTO Property_Photos VALUES (1, 1, empty_blob());
-- INSERT INTO Property_Photos VALUES (2, 2, empty_blob());
-- INSERT INTO Property_Photos VALUES (3, 3, empty_blob());
-- INSERT INTO Property_Photos VALUES (4, 4, empty_blob());
-- INSERT INTO Property_Photos VALUES (5, 5, empty_blob());
-- INSERT INTO Property_Photos VALUES (6, 6, empty_blob());
-- INSERT INTO Property_Photos VALUES (7, 7, empty_blob());
-- INSERT INTO Property_Photos VALUES (8, 8, empty_blob());
-- INSERT INTO Property_Photos VALUES (9, 9, empty_blob());
-- INSERT INTO Property_Photos VALUES (10, 10, empty_blob());
-- INSERT INTO Property_Photos VALUES (11, 11, empty_blob());
-- INSERT INTO Property_Photos VALUES (12, 12, empty_blob());
-- INSERT INTO Property_Photos VALUES (13, 13, empty_blob());
-- INSERT INTO Property_Photos VALUES (14, 14, empty_blob());
-- INSERT INTO Property_Photos VALUES (15, 15, empty_blob());
-- INSERT INTO Property_Photos VALUES (16, 16, empty_blob());
-- INSERT INTO Property_Photos VALUES (17, 17, empty_blob());
-- INSERT INTO Property_Photos VALUES (18, 18, empty_blob());
-- INSERT INTO Property_Photos VALUES (19, 19, empty_blob());
-- INSERT INTO Property_Photos VALUES (20, 20, empty_blob());


INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (1, 1, 1, TO_DATE('2024-09-12', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (2, 2, 1, TO_DATE('2023-08-30', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (3, 3, 1, TO_DATE('2024-10-05', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (4, 4, 1, TO_DATE('2022-09-18', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (5, 5, 1, TO_DATE('2021-09-26', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (6, 6, 1, TO_DATE('2020-08-15', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (7, 7, 1, TO_DATE('2024-10-01', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (8, 8, 1, TO_DATE('2023-09-20', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (9, 9, 0, NULL, empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (10, 10, 1, TO_DATE('2023-09-10', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (11, 11, 1, TO_DATE('2022-08-31', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (12, 12, 1, TO_DATE('2023-09-07', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (13, 13, 1, TO_DATE('2021-10-03', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (14, 14, 1, TO_DATE('2023-09-22', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (15, 15, 1, TO_DATE('2024-09-15', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (16, 16, 1, TO_DATE('2020-09-05', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (17, 17, 1, TO_DATE('2021-09-25', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (18, 18, 1, TO_DATE('2024-08-20', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (19, 19, 0, NULL, empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (20, 20, 1, TO_DATE('2023-09-14', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (21, 21, 1, TO_DATE('2024-10-08', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (22, 22, 1, TO_DATE('2019-09-19', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (23, 23, 1, TO_DATE('2020-10-06', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (24, 24, 1, TO_DATE('2021-08-30', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (25, 25, 1, TO_DATE('2023-09-03', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (26, 26, 0, NULL, empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (27, 27, 1, TO_DATE('2020-10-10', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (28, 28, 1, TO_DATE('2024-09-17', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (29, 29, 1, TO_DATE('2022-09-05', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (30, 30, 1, TO_DATE('2021-08-27', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (31, 31, 1, TO_DATE('2024-09-17', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (32, 32, 1, TO_DATE('2019-10-01', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (33, 33, 0, NULL, empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (34, 34, 1, TO_DATE('2022-09-12', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (35, 35, 1, TO_DATE('2021-09-14', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (36, 36, 1, TO_DATE('2023-10-06', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (37, 37, 1, TO_DATE('2020-08-30', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (38, 38, 1, TO_DATE('2024-09-03', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (39, 39, 1, TO_DATE('2024-10-06', 'YYYY-MM-DD'), empty_blob());
INSERT INTO Govt_Verification (Verification_Id, Property_Id, Verification_Status, Verification_Date, Proof_Of_Ownership) VALUES (40, 40, 1, TO_DATE('2019-09-02', 'YYYY-MM-DD'), empty_blob());


INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (1, 'Amit_Kumar_1985', 'seller_rohan_patil_1980', 1, 'admin_arun_sinha_1987', 2500000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (2, 'Priya_Singh_1990', 'seller_sita_ramesh_1983', 2, 'admin_geeta_das_1991', 4000000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (3, 'Rahul_Verma_1988', 'seller_vishal_rao_1982', 3, 'admin_sujata_rao_1985', 5200000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (4, 'Sneha_Mishra_1992', 'seller_manoj_verma_1981', 4, 'admin_amit_verma_1989', 3500000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (5, 'Vikram_Sharma_1987', 'seller_rahul_malhotra_1984', 5, 'admin_manoj_sharma_1983', 2800000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (6, 'Neha_Rani_1995', 'seller_preeti_singh_1985', 6, 'admin_riya_bhatia_1990', 4300000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (7, 'Rahul_Agarwal_1993', 'seller_kavita_jain_1987', 7, 'admin_kavita_kulkarni_1988', 4600000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (8, 'Sita_Malhotra_1984', 'seller_ravi_kumar_1988', 8, 'admin_ravi_singh_1986', 3000000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (9, 'Ajay_Patel_1991', 'seller_suman_nair_1990', 9, 'admin_preeti_joshi_1982', 2500000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (10, 'Kavita_Desai_1989', 'seller_mohan_iyer_1986', 10, 'admin_deepak_mishra_1992', 3800000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (11, 'Ravi_Sharma_1986', 'seller_sandeep_joshi_1989', 11, 'admin_vivek_kumar_1984', 5100000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (12, 'Anjali_Kumar_1994', 'seller_ajay_kumar_1982', 12, 'admin_sneha_tandon_1987', 6000000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (13, 'Suresh_Nath_1982', 'seller_ravi_singh_1986', 13, 'admin_priya_patel_1990', 5600000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (14, 'Pooja_Jain_1990', 'seller_rakesh_rao_1988', 14, 'admin_rajesh_mehta_1988', 4700000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (15, 'Manish_Gupta_1983', 'seller_maya_nair_1991', 15, 'admin_neha_agrawal_1993', 4500000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (16, 'Aishwarya_Rao_1995', 'seller_arun_sinha_1987', 16, 'admin_vikas_malhotra_1991', 4800000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (17, 'Vijay_Khan_1988', 'seller_geeta_das_1991', 17, 'admin_rekha_nair_1986', 2900000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (18, 'Nisha_Sharma_1991', 'seller_sujata_rao_1985', 18, 'admin_ankit_banerjee_1985', 5000000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (19, 'Sunil_Singh_1990', 'seller_amit_verma_1989', 19, 'admin_rahul_shah_1989', 6200000);
INSERT INTO Enquiry (Enquiry_Id, Buyer_Id, Seller_Id, Property_Id, Admin_Id, Final_Amount) VALUES (20, 'Nitin_Tiwari_1985', 'seller_kavita_kulkarni_1988', 20, 'admin_shalini_prasad_1992', 4700000);


INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (1, 1, 'Amit_Kumar_1985', 'seller_rohan_patil_1980', NULL, 'Hi, Im interested in the property listed. Is it still available?', TO_TIMESTAMP('2023-10-01 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (1, 2, 'Amit_Kumar_1985', 'seller_rohan_patil_1980', NULL, 'Could you please provide more details?', TO_TIMESTAMP('2023-10-01 09:32:15', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (1, 3, 'Amit_Kumar_1985', 'seller_rohan_patil_1980', NULL, 'Id like to know about the amenities.', TO_TIMESTAMP('2023-10-01 09:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (1, 4, 'Amit_Kumar_1985', 'seller_rohan_patil_1980', NULL, 'Yes, the property is available. It has 3 bedrooms and a swimming pool.', TO_TIMESTAMP('2023-10-01 09:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (1, 5, 'Amit_Kumar_1985', 'seller_rohan_patil_1980', NULL, 'There is also a gym and parking for two cars.', TO_TIMESTAMP('2023-10-01 09:42:30', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (2, 1, 'Priya_Singh_1990', 'seller_sita_ramesh_1983', NULL, 'Hello! Im looking for a 2BHK apartment. Is yours still on the market?', TO_TIMESTAMP('2023-10-01 10:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (2, 2, 'Priya_Singh_1990', 'seller_sita_ramesh_1983', NULL, 'Yes, its still available. Would you like to schedule a visit?', TO_TIMESTAMP('2023-10-01 10:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (2, 3, 'Priya_Singh_1990', 'seller_sita_ramesh_1983', NULL, 'That would be great! When is a good time?', TO_TIMESTAMP('2023-10-01 10:25:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (2, 4, 'Priya_Singh_1990', 'seller_sita_ramesh_1983', NULL, 'How about tomorrow at 5 PM?', TO_TIMESTAMP('2023-10-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (2, 5, 'Priya_Singh_1990', 'seller_sita_ramesh_1983', NULL, 'Perfect! Ill see you then.', TO_TIMESTAMP('2023-10-01 10:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (3, 1, 'Rahul_Verma_1988', 'seller_vishal_rao_1982', NULL, 'Hi, I have a question about the property location.', TO_TIMESTAMP('2023-10-02 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (3, 2, 'Rahul_Verma_1988', 'seller_vishal_rao_1982', NULL, 'Is it close to public transport?', TO_TIMESTAMP('2023-10-02 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (3, 3, 'Rahul_Verma_1988', 'seller_vishal_rao_1982', NULL, 'Yes, its a 5-minute walk to the nearest metro station.', TO_TIMESTAMP('2023-10-02 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (3, 4, 'Rahul_Verma_1988', 'seller_vishal_rao_1982', NULL, 'There are also several bus stops nearby.', TO_TIMESTAMP('2023-10-02 11:12:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (4, 1, 'Sneha_Mishra_1992', 'seller_manoj_verma_1981', NULL, 'Hello, can you tell me the final price for the property?', TO_TIMESTAMP('2023-10-02 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (4, 2, 'Sneha_Mishra_1992', 'seller_manoj_verma_1981', NULL, 'The listed price is 75 lakhs. Its negotiable.', TO_TIMESTAMP('2023-10-02 13:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (4, 3, 'Sneha_Mishra_1992', 'seller_manoj_verma_1981', NULL, 'What is the area of the property?', TO_TIMESTAMP('2023-10-02 13:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (4, 4, 'Sneha_Mishra_1992', 'seller_manoj_verma_1981', NULL, 'Its approximately 1500 square feet.', TO_TIMESTAMP('2023-10-02 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (5, 1, 'Vikram_Sharma_1987', 'seller_rahul_malhotra_1984', NULL, 'I saw your listing. Can you send me more photos?', TO_TIMESTAMP('2023-10-03 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (5, 2, 'Vikram_Sharma_1987', 'seller_rahul_malhotra_1984', NULL, 'Sure! Ill send them over shortly.', TO_TIMESTAMP('2023-10-03 09:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (5, 3, 'Vikram_Sharma_1987', 'seller_rahul_malhotra_1984', NULL, 'Do you have any specific areas youd like to see?', TO_TIMESTAMP('2023-10-03 09:06:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (6, 1, 'Neha_Rani_1995', 'seller_preeti_singh_1985', NULL, 'Hi, Im interested in the garden area of the property.', TO_TIMESTAMP('2023-10-03 10:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (6, 2, 'Neha_Rani_1995', 'seller_preeti_singh_1985', NULL, 'The garden is quite spacious and well-maintained.', TO_TIMESTAMP('2023-10-03 10:25:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (6, 3, 'Neha_Rani_1995', 'seller_preeti_singh_1985', NULL, 'Does it have a dedicated space for kids?', TO_TIMESTAMP('2023-10-03 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (6, 4, 'Neha_Rani_1995', 'seller_preeti_singh_1985', NULL, 'Yes, theres a play area for children.', TO_TIMESTAMP('2023-10-03 10:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (7, 1, 'Rahul_Agarwal_1993', 'seller_kavita_jain_1987', NULL, 'Is the property pet-friendly?', TO_TIMESTAMP('2023-10-04 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (7, 2, 'Rahul_Agarwal_1993', 'seller_kavita_jain_1987', NULL, 'Yes, pets are allowed in the property.', TO_TIMESTAMP('2023-10-04 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (7, 3, 'Rahul_Agarwal_1993', 'seller_kavita_jain_1987', NULL, 'Great! I have two dogs.', TO_TIMESTAMP('2023-10-04 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (8, 1, 'Sita_Malhotra_1984', 'seller_ravi_kumar_1988', NULL, 'Can we discuss the payment terms?', TO_TIMESTAMP('2023-10-05 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (8, 2, 'Sita_Malhotra_1984', 'seller_ravi_kumar_1988', NULL, 'Sure! I usually prefer a 20% down payment.', TO_TIMESTAMP('2023-10-05 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (8, 3, 'Sita_Malhotra_1984', 'seller_ravi_kumar_1988', NULL, 'What about the rest?', TO_TIMESTAMP('2023-10-05 14:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (8, 4, 'Sita_Malhotra_1984', 'seller_ravi_kumar_1988', NULL, 'The remaining amount can be paid in installments.', TO_TIMESTAMP('2023-10-05 14:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (9, 1, 'Ajay_Patel_1991', 'seller_suman_nair_1990', NULL, 'I want to confirm the property is not under any legal issues.', TO_TIMESTAMP('2023-10-06 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (9, 2, 'Ajay_Patel_1991', 'seller_suman_nair_1990', NULL, 'Yes, the property is clear of any legal disputes.', TO_TIMESTAMP('2023-10-06 15:32:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (10, 1, 'Kavita_Desai_1989', 'seller_mohan_iyer_1986', NULL, 'Hi! Is there a balcony with the apartment?', TO_TIMESTAMP('2023-10-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (10, 2, 'Kavita_Desai_1989', 'seller_mohan_iyer_1986', NULL, 'Yes, each apartment has a balcony.', TO_TIMESTAMP('2023-10-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (10, 3, 'Kavita_Desai_1989', 'seller_mohan_iyer_1986', NULL, 'I love balconies! How big are they?', TO_TIMESTAMP('2023-10-07 12:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (10, 4, 'Kavita_Desai_1989', 'seller_mohan_iyer_1986', NULL, 'They are spacious enough for a small table and chairs.', TO_TIMESTAMP('2023-10-07 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (11, 1, 'Ravi_Sharma_1986', 'seller_sandeep_joshi_1989', NULL, 'Hello, is there a maintenance charge for the property?', TO_TIMESTAMP('2023-10-08 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (11, 2, 'Ravi_Sharma_1986', 'seller_sandeep_joshi_1989', NULL, 'Yes, there is a monthly maintenance charge.', TO_TIMESTAMP('2023-10-08 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (11, 3, 'Ravi_Sharma_1986', 'seller_sandeep_joshi_1989', NULL, 'How much is it?', TO_TIMESTAMP('2023-10-08 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (11, 4, 'Ravi_Sharma_1986', 'seller_sandeep_joshi_1989', NULL, 'Its around 2000 per month.', TO_TIMESTAMP('2023-10-08 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (12, 1, 'Anjali_Kumar_1994', 'seller_ajay_kumar_1982', NULL, 'Can I see the property this weekend?', TO_TIMESTAMP('2023-10-09 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (12, 2, 'Anjali_Kumar_1994', 'seller_ajay_kumar_1982', NULL, 'Yes, Saturday works for me.', TO_TIMESTAMP('2023-10-09 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (12, 3, 'Anjali_Kumar_1994', 'seller_ajay_kumar_1982', NULL, 'What time should I come?', TO_TIMESTAMP('2023-10-09 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (12, 4, 'Anjali_Kumar_1994', 'seller_ajay_kumar_1982', NULL, 'Lets say 3 PM?', TO_TIMESTAMP('2023-10-09 10:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (13, 1, 'Suresh_Nath_1982', 'seller_ravi_singh_1986', NULL, 'Is the kitchen modular?', TO_TIMESTAMP('2023-10-10 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (13, 2, 'Suresh_Nath_1982', 'seller_ravi_singh_1986', NULL, 'Yes, the kitchen is fully modular with storage.', TO_TIMESTAMP('2023-10-10 12:32:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (13, 3, 'Suresh_Nath_1982', 'seller_ravi_singh_1986', NULL, 'Thats great to hear! Are appliances included?', TO_TIMESTAMP('2023-10-10 12:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (13, 4, 'Suresh_Nath_1982', 'seller_ravi_singh_1986', NULL, 'No, appliances are not included.', TO_TIMESTAMP('2023-10-10 12:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (14, 1, 'Pooja_Jain_1990', 'seller_rakesh_rao_1988', NULL, 'Can you tell me about the nearby schools?', TO_TIMESTAMP('2023-10-11 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (14, 2, 'Pooja_Jain_1990', 'seller_rakesh_rao_1988', NULL, 'Yes, there are several good schools within a 2 km radius.', TO_TIMESTAMP('2023-10-11 08:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (14, 3, 'Pooja_Jain_1990', 'seller_rakesh_rao_1988', NULL, 'That sounds perfect for my kids!', TO_TIMESTAMP('2023-10-11 08:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (15, 1, 'Manish_Gupta_1983', 'seller_maya_nair_1991', NULL, 'Is there a parking space included?', TO_TIMESTAMP('2023-10-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (15, 2, 'Manish_Gupta_1983', 'seller_maya_nair_1991', NULL, 'Yes, theres dedicated parking for one car.', TO_TIMESTAMP('2023-10-12 09:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (15, 3, 'Manish_Gupta_1983', 'seller_maya_nair_1991', NULL, 'Can I get a second parking space?', TO_TIMESTAMP('2023-10-12 09:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (15, 4, 'Manish_Gupta_1983', 'seller_maya_nair_1991', NULL, 'That can be arranged for an extra fee.', TO_TIMESTAMP('2023-10-12 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (16, 1, 'Aishwarya_Rao_1995', 'seller_arun_sinha_1987', NULL, 'Hello! Whats the age of the property?', TO_TIMESTAMP('2023-10-13 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (16, 2, 'Aishwarya_Rao_1995', 'seller_arun_sinha_1987', NULL, 'The property is 5 years old.', TO_TIMESTAMP('2023-10-13 14:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (16, 3, 'Aishwarya_Rao_1995', 'seller_arun_sinha_1987', NULL, 'Has it been well-maintained?', TO_TIMESTAMP('2023-10-13 14:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (16, 4, 'Aishwarya_Rao_1995', 'seller_arun_sinha_1987', NULL, 'Yes, its been well-maintained.', TO_TIMESTAMP('2023-10-13 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (17, 1, 'Vijay_Khan_1988', 'seller_geeta_das_1991', NULL, 'Can you tell me about the energy efficiency of the property?', TO_TIMESTAMP('2023-10-14 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (17, 2, 'Vijay_Khan_1988', 'seller_geeta_das_1991', NULL, 'The property has solar panels and good insulation.', TO_TIMESTAMP('2023-10-14 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (18, 1, 'Nisha_Sharma_1991', 'seller_sujata_rao_1985', NULL, 'Is there a backup power system in place?', TO_TIMESTAMP('2023-10-15 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (18, 2, 'Nisha_Sharma_1991', 'seller_sujata_rao_1985', NULL, 'Yes, theres a generator for backup power.', TO_TIMESTAMP('2023-10-15 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (19, 1, 'Sunil_Singh_1990', 'seller_amit_verma_1989', NULL, 'Hi! I would like to know about the flooring material.', TO_TIMESTAMP('2023-10-16 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (19, 2, 'Sunil_Singh_1990', 'seller_amit_verma_1989', NULL, 'The living areas have marble flooring, and the bedrooms have wooden flooring.', TO_TIMESTAMP('2023-10-16 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (20, 1, 'Nitin_Tiwari_1985', 'seller_kavita_kulkarni_1988', NULL, 'Is there a homeowners association fee?', TO_TIMESTAMP('2023-10-17 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Buyer');
INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Admin_Id, Message, Time_Stamp, Sent_By) VALUES (20, 2, 'Nitin_Tiwari_1985', 'seller_kavita_kulkarni_1988', NULL, 'Yes, theres an HOA fee of 1500 per month.', TO_TIMESTAMP('2023-10-17 09:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Seller');


INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (1, 1, 4, 'Very helpful and responsive!');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (2, 2, 5, 'Excellent service, highly recommended!');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (3, 3, 3, 'Average experience, could be better.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (4, 4, 2, 'Did not receive a timely response.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (5, 5, 4, 'Good information provided.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (6, 6, 5, 'Very professional!');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (7, 7, 4, 'Had a good experience.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (8, 8, 3, 'Okay service, nothing special.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (9, 9, 5, 'Superb, thanks for the help!');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (10, 10, 4, 'Happy with the service.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (11, 11, 2, 'Not satisfied with the assistance.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (12, 12, 5, 'Great experience overall!');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (13, 13, 4, 'Helpful staff.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (14, 14, 5, 'Very responsive and helpful.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (15, 15, 3, 'Average service.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (16, 16, 4, 'Good information provided.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (17, 17, 2, 'Not very helpful.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (18, 18, 5, 'Excellent service!');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (19, 19, 4, 'Had a good experience.');
INSERT INTO Feedback (Feedback_Id, Enquiry_Id, Rating, Feedback) VALUES (20, 20, 5, 'Superb, very professional!');


INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (1, 1, 'Bank Transfer', 'txn231325');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (2, 2, 'Credit Card', 'txn231326');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (3, 3, 'Cash', 'txn231327');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (4, 4, 'Debit Card', 'txn231328');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (5, 5, 'Net Banking', 'txn231329');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (6, 6, 'Cash', 'txn231330');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (7, 7, 'Bank Transfer', 'txn231331');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (8, 8, 'Credit Card', 'txn231332');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (9, 9,'Debit Card', 'txn231333');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (10, 10, 'Net Banking', 'txn231334');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (11, 11, 'Cash', 'txn231335');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (12, 12, 'Bank Transfer', 'txn231336');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (13, 13, 'Credit Card', 'txn231337');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (14, 14, 'Debit Card', 'txn231338');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (15, 15, 'Net Banking', 'txn231339');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (16, 16, 'Cash', 'txn231340');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (17, 17, 'Bank Transfer', 'txn231341');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (18, 18, 'Credit Card', 'txn231342');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (19, 19, 'Debit Card', 'txn231343');
INSERT INTO Payment (Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id) VALUES (20, 20, 'Net Banking', 'txn231344');


INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (1, 1, 1, 'doc34325');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (2, 2, 2, 'doc34326');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (3, 3, 3, 'doc34327');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (4, 4, 4, 'doc34328');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (5, 5, 5, 'doc34329');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (6, 6, 6, 'doc34330');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (7, 7, 7, 'doc34331');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (8, 8, 8, 'doc34332');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (9, 9, 9, 'doc34333');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (10, 10, 10, 'doc34334');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (11, 11, 5, 'doc34335');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (12, 12, 14, 'doc34336');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (13, 13, 15, 'doc34337');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (14, 14, 3, 'doc34338');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (15, 15, 20, 'doc34339');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (16, 16, 21, 'doc34340');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (17, 17, 8, 'doc34341');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (18, 18, 7, 'doc34342');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (19, 19, 6, 'doc34343');
INSERT INTO Registrations (Registration_Id, Payment_Id, Reg_Off_Id, Document_Number) VALUES (20, 20, 10, 'doc34344');