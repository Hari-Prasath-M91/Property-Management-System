import streamlit as st
import pandas as pd
import cx_Oracle
import base64
from urllib.parse import urlencode

# cx_Oracle.init_oracle_client(lib_dir=r"D:\Programs\oracle\instantclient_23_5")
host = '172.17.9.65'  
port = 1521
sid = 'xe'
username = 'das22119'
password = 'oracle'

dsn = cx_Oracle.makedsn(host, port, sid=sid)

conn = cx_Oracle.connect(user=username, password=password, dsn=dsn)

cursor = conn.cursor()

st.set_page_config(page_title = "Property Management System", page_icon="🏘️", initial_sidebar_state='collapsed', layout='wide')

query_params = st.query_params

def Retrieve_Image(cursor, Property_Id, Photo_Id):
    cursor.execute("SELECT Photo_Id,Photo FROM Property_Photos WHERE Property_Id = :Property_Id and Photo_Id = :Photo_Id", [Property_Id, Photo_Id])
    Pic = cursor.fetchone()
    if Pic:
        Photo_Id, Photo = Pic
        return Photo.read()
    else:
        return None

def add_user(role, username, password, name, phone, mail):
    try:
        if role == 'Admin':
            cursor.execute("INSERT INTO Admin VALUES (:1, :2, :3, :4, :5)", (username, password, name, phone, mail))
        elif role == 'Buyer':
            cursor.execute("INSERT INTO Buyer VALUES (:1, :2, :3, :4, :5)", (username, password, name, phone, mail))
        elif role == 'Seller':
            cursor.execute("INSERT INTO Seller VALUES (:1, :2, :3, :4, :5)", (username, password, name, phone, mail))
        conn.commit()
        st.success('User registered successfully, please log in.')
    except cx_Oracle.IntegrityError:
        st.error('The username is already taken')

def login_user(role, username, password):
    if role == 'Admin':
        cursor.execute("SELECT * FROM Admin WHERE Admin_Id = :1 AND Password = :2", (username, password))
    elif role == 'Buyer':
        cursor.execute("SELECT * FROM Buyer WHERE Buyer_Id = :1 AND Password = :2", (username, password))
    elif role == 'Seller':
        cursor.execute("SELECT * FROM Seller WHERE Seller_Id = :1 AND Password = :2", (username, password))
    return cursor.fetchone()
    
if 'role' not in query_params:
    st.title('Property Management System')

    if 'role' not in query_params:
        tab1, tab2 = st.tabs(["Login", "Register"])
        with tab1:
            role = st.selectbox('Select Role', ['Buyer', 'Seller', 'Admin'])
            username = st.text_input('Username', placeholder='Enter Your Username')
            password = st.text_input('Password', type='password', placeholder='Enter Your Password')
            if st.button('Login'):
                user = login_user(role, username, password)
                if user:
                    st.success(f'Welcome, {username}!')
                    query_params['role'] = role
                    query_params['username'] = username
                    st.rerun()
                else:
                    st.error('Invalid username or password')
        with tab2:
            # st.markdown("<div style='display: flex; justify-content: center;'>", unsafe_allow_html=True)
            role = st.selectbox('Select Role', ['Buyer', 'Seller', 'Admin'], key = 'login_role')
            username = st.text_input('Username', placeholder='Enter Your Username', key = 'login_user')
            password = st.text_input('Password', type='password', placeholder='Enter Your Password', key = 'login_pass')
            name = st.text_input('Name', placeholder='Enter Your Name')
            phone = st.text_input('Phone Number', placeholder='Enter your Phone Number')
            mail = st.text_input('Mail Id', placeholder='Enter your Email Id')
            if st.button('Register'):
                add_user(role, username, password, name, phone, mail)
    else:
        st.success(f"Logged in as {query_params['username']}")

elif "property_id" in query_params:
    property_id = query_params["property_id"]
    cursor.execute("""
        SELECT p.*, s.Name as Seller_Name, s.Phone_No, s.Mail_Id, gv.Verification_Status, gv.Verification_Date
        FROM Property p JOIN Seller s ON p.Seller_Id = s.Seller_Id
        JOIN Govt_Verification gv ON p.Verification_Id = gv.Verification_Id
        WHERE p.Property_Id = :1
    """, [property_id])
    
    property_data = cursor.fetchone()
    
    if property_data:
        st.title(property_data[3])
        
        details_tab, photos_tab, enquiry_tab = st.tabs(["Details", "Photos", "Make Enquiry"])
        
        with details_tab:
            col1, col2 = st.columns([2, 1])
            
            with col1:
                st.subheader("Property Overview")
                st.write(f"**Type:** {property_data[2]}")
                st.write(f"**Listed For:** {property_data[4]}")
                st.write(f"**Price:** ₹{property_data[6]:,}")
                st.write(f"**Location:** {property_data[1]}")
                
                st.divider()
                
                st.subheader("Description")
                st.write(property_data[5])
                
                st.divider()
                verification_status = "✅ Verified" if property_data[-2] == 1 else "⏳ Pending Verification"
                verification_date = property_data[-1].strftime("%d %B %Y") if property_data[-1] else "Pending"
                st.write(f"**Verification Status:** {verification_status}")
                if property_data[-2] == 1:
                    st.write(f"**Verified On:** {verification_date}")
            
            with col2:
                st.subheader("Seller Information")
                st.write(f"**Name:** {property_data[-5]}")
                st.write(f"**Phone:** {property_data[-4]}")
                st.write(f"**Email:** {property_data[-3]}")
        
        with photos_tab:
            cursor.execute("SELECT Photo_Id, Photo FROM Property_Photos WHERE Property_Id = :1 ORDER BY Photo_Id", [property_id])
            
            photos = cursor.fetchall()
            
            if photos:
                cols = st.columns(3)
                for idx, photo in enumerate(photos):
                    with cols[idx % 3]:
                        image_data = photo[1].read()
                        if image_data:
                            st.image(image_data)
            else:
                st.info("No photos available for this property.")
        
        with enquiry_tab:
            cursor.execute("SELECT Enquiry_Id, Final_Amount FROM Enquiry WHERE Property_Id = :1 AND Buyer_Id = :2", 
                            [property_id, query_params['username']])
            
            existing_enquiry = cursor.fetchone()
            
            if existing_enquiry:
                st.info(f"You have already made an enquiry for this property. Your offered amount: ₹{existing_enquiry[1]:,}")
                
                cursor.execute("SELECT Message, Time_Stamp, Sent_By FROM Conversations WHERE Enquiry_Id = :1 ORDER BY Time_Stamp", 
                                [existing_enquiry[0]])
                
                messages = cursor.fetchall()
                
                if messages:
                    st.subheader("Conversation History")
                    for msg in messages:
                        align = "left" if msg[2] != "Buyer" else "right"
                        st.markdown(f"""
                            <div style="text-align: {align};">
                                <div style="display: inline-block; 
                                            background-color: {'#1E1E1E' if msg[2] != 'Buyer' else '#2E7D32'}; 
                                            padding: 10px; 
                                            border-radius: 10px; 
                                            margin: 5px;">
                                    <p style="margin: 0;">{msg[0]}</p>
                                    <small style="color: #DDD;">{msg[1].strftime('%d %b %Y, %H:%M')}</small>
                                </div>
                            </div>
                        """, unsafe_allow_html=True)
                    
                    with st.form(key=f"msg_form", clear_on_submit=True):
                        new_message = st.text_input("Type your message", key="message_input")
                        if st.form_submit_button("Send"):
                            if new_message.strip():
                                cursor.execute("SELECT MAX(Message_Id) FROM Conversations WHERE Enquiry_Id = :1", [existing_enquiry[0]])
                                
                                max_msg_id = cursor.fetchone()[0]
                                if max_msg_id == None:
                                    max_msg_id = 0
                                
                                cursor.execute("""INSERT INTO Conversations (Enquiry_Id, Message_Id, Buyer_Id, Seller_Id, Message, 
                                                Time_Stamp, Sent_By) VALUES (:1, :2, :3, :4, :5, CURRENT_TIMESTAMP, 'Buyer')""", 
                                                [existing_enquiry[0], max_msg_id + 1, query_params['username'], 
                                                property_data[7], new_message])
                                conn.commit()
                                st.rerun()
        
                with st.form(key="Reg_Req", clear_on_submit=True):
                    cursor.execute("""
                        SELECT MAX(Message_Id) 
                        FROM Conversations 
                        WHERE Enquiry_Id = :1
                    """, [existing_enquiry[0]])
                    
                    max_msg_id = cursor.fetchone()[0]
                    next_msg_id = 1 if max_msg_id is None else max_msg_id + 1
                    
                    cursor.execute("SELECT Message FROM Conversations WHERE Enquiry_Id = :1 ORDER BY Time_Stamp", [existing_enquiry[0]])            
                    msg = cursor.fetchall()

                    if (f"I would like to proceed with the registration, Could you please confirm your acceptance to move forward. Property: {property_data[3]} - Final Agreed Amount: ₹{existing_enquiry[1]:,}",) not in msg:
                        amt = st.number_input('With This Final Amount, ', value=existing_enquiry[1], step=10000)
                        if st.form_submit_button("Send Request for Registration"):
                            registration_message = f"I would like to proceed with the registration, Could you please confirm your acceptance to move forward. Property: {property_data[3]} - Final Agreed Amount: ₹{amt:,}"
                            try:
                                cursor.execute("""
                                    INSERT INTO Conversations (
                                        Enquiry_Id, Message_Id, Buyer_Id, Seller_Id,
                                        Message, Time_Stamp, Sent_By
                                    ) VALUES (
                                        :1, :2, :3, :4, :5, CURRENT_TIMESTAMP, 'Buyer'
                                    )
                                """, [existing_enquiry[0], next_msg_id, query_params['username'], 
                                    property_data[7], registration_message])
                                
                                cursor.execute("Update Enquiry Set Final_Amount = :1 where Enquiry_Id = :2 ", [amt, existing_enquiry[0]])
                                conn.commit()
                                st.success("Registration request sent successfully!")
                                st.rerun()
                                
                            except Exception as e:
                                conn.rollback()
                                st.error(f"Error sending registration request: {str(e)}")
            else:
                with st.form("enquiry_form"):
                    st.write("Make an Enquiry")
                    offered_amount = st.number_input(
                        "Your Offered Amount (₹)", 
                        min_value=0, 
                        value=property_data[6],
                        step=10000
                    )
                    
                    initial_message = st.text_area(
                        "Initial Message", 
                        placeholder="You can Introduce yourself and ask any questions you have about the property..."
                    )
                    
                    if st.form_submit_button("Submit Enquiry"):
                        if offered_amount and initial_message:
                            try:
                                cursor.execute("SELECT MAX(Enquiry_Id) FROM Enquiry")
                                max_enq_id = cursor.fetchone()[0]
                                if max_enq_id == None:
                                    max_enq_id = 0
                                new_enq_id = max_enq_id + 1
                                
                                cursor.execute("""INSERT INTO Enquiry VALUES (:1, :2, :3, :4, (SELECT Admin_Id FROM Admin WHERE ROWNUM = 1), 
                                                :5)""", [new_enq_id, query_params['username'], property_data[7], property_id, offered_amount])
                                
                                cursor.execute("""
                                    INSERT INTO Conversations (
                                        Enquiry_Id, Message_Id, Buyer_Id, Seller_Id,
                                        Message, Time_Stamp, Sent_By
                                    ) VALUES (
                                        :1, 1, :2, :3, :4, CURRENT_TIMESTAMP, 'Buyer'
                                    )
                                """, [new_enq_id, query_params['username'], property_data[7], initial_message])
                                
                                conn.commit()
                                st.success("Enquiry submitted successfully!")
                                st.rerun()
                                
                            except Exception as e:
                                conn.rollback()
                                st.error(f"An error occurred: {str(e)}")
                        else:
                            st.error("Please fill in all fields.")
    else:
        st.error("Property not found!")

elif query_params['role'] == 'Buyer':
    query = "SELECT Property_Id, Listing_Title, Listing_Price FROM Property WHERE 1=1"
    params = []

    st.sidebar.write("I want to buy a: ")
    prop_type = st.sidebar.selectbox("I want to buy a: ", ["Choose an Option", "Residential Property", "Commercial Property", "Plot/Land"], label_visibility="collapsed")

    if prop_type != "Choose an Option":
        query += " and Type = :prop_type"
        params.append(prop_type)


    st.sidebar.write('I want to: ')
    if prop_type == "Residential Property":
        type = st.sidebar.selectbox('', ["Choose an Option", 'Rent it', 'Buy it'], label_visibility='collapsed')
    elif prop_type == "Commercial Property":
        type = st.sidebar.selectbox('', ["Choose an Option", 'Rent it', 'Lease it', 'Buy it'], label_visibility='collapsed')
    else:
        type = st.sidebar.selectbox('', ["Choose an Option", 'Rent it', 'Lease it', 'Buy it'], label_visibility='collapsed')

    if prop_type and type != "Choose an Option":
        if type == "Buy it":
            type = 'For Sale'
        else:
            type = 'For '+ type.split(' ')[0]
        query += " and Listing_Type = :type"
        params.append(type)


    with st.sidebar:
        st.write("I want it to be in: ")
        df = pd.read_csv(r"D:\Projects\Property Management System\Frontend\Sub-Districts in India.csv")
        col1, col2 = st.columns(2)
        with col1:
            state = st.selectbox("State", ['Choose an Option']+df['State'].drop_duplicates().to_list())
            df = df[df['State'] == state]
        with col2:
            district = st.selectbox("District", ["Choose an Option"]+df['District'].drop_duplicates().to_list())
            df = df[df['District'] == district]
        sub_dist = st.selectbox("Sub-District", ["Choose an Option"]+df['Sub-District'].to_list())

    if prop_type and type and state != "Choose an Option":
        query += " and Address LIKE '%' || :state || '%'"
        params.append(state)
    if prop_type and type and state and district != "Choose an Option":
        query += " and Address LIKE '%' || :district || '%'"
        params.append(district)
    if prop_type and type and state and district and sub_dist != "Choose an Option":
        query += " and Address LIKE '%' || :sub_dist || '%'"
        params.append(sub_dist)

    with st.sidebar:
        st.write("I want it in budget: ")
        col1, col2 = st.columns(2)
        with col1:
            min_budget = st.number_input("Enter Min Budget", min_value=0, value=0, step=10000)
        with col2:
            max_budget = st.number_input("Enter Max Budget", min_value=0, value=10**9, step=10000)
        if min_budget > max_budget:
            st.error("Minimum budget cannot be greater than the maximum budget.")
    if prop_type and type and state and district and sub_dist and max_budget != "Choose an Option":
        query += " and Listing_Price BETWEEN :min_budget AND :max_budget"
        params.append(min_budget)
        params.append(max_budget)

    if prop_type != "Choose an Option":
        cursor.execute(query, params)
        datas = cursor.fetchall()
        st.subheader("Choose your Dream Property")
        cols = st.columns(3)
        idx = 0
        if len(datas) != 0:
            for data in datas:
                with cols[idx % 3]:
                    image_data = Retrieve_Image(cursor, int(data[0]), 1)
                    if image_data:
                        base64_image = base64.b64encode(image_data).decode()
                        with st.form(key=f"form_{data[0]}"):
                            st.write(data[1])
                            st.markdown(f'''
                                <div style="text-align: center; cursor: pointer;">
                                    <img src="data:image/jpeg;base64,{base64_image}" style="width:275px; height:200px; object-fit: cover;" />
                                    <p style="font-size: 16px; color: white; margin-top: 5px;">Price: ₹{data[2]}</p>
                                </div>
                            ''', unsafe_allow_html=True)

                            submitted = st.form_submit_button(label="View Details", use_container_width=True)
                            if submitted:
                                query_params['property_id']=data[0]
                                url = urlencode(query_params, doseq=True)
                                st.markdown(f"""<div style="text-align: center;">
                                            <a href="?{url}" target="_blank" style="font-size: 16px; text-decoration: none;">
                                            Click to Open Details in New Tab</a></div>""", unsafe_allow_html=True)
                                del query_params['property_id']                          
                    else:
                        with open(r"D:\Projects\Property Management System\Backend\Property Photos\No_Image_Available.png", 'rb') as file:
                            image_data = file.read()
                        base64_image = base64.b64encode(image_data).decode()
                        with st.form(key=f"form_{data[0]}"):
                            st.write(data[1])
                            st.markdown(f'''
                                <div style="text-align: center; cursor: pointer;">
                                    <img src="data:image/jpeg;base64,{base64_image}" style="width:275px; height:200px; object-fit: cover;" />
                                    <p style="font-size: 16px; color: white; margin-top: 5px;">Price: ₹{data[2]}</p>
                                </div>
                            ''', unsafe_allow_html=True)

                            submitted = st.form_submit_button(label="View Details", use_container_width=True)
                            if submitted:
                                query_params['property_id']=data[0]
                                url = urlencode(query_params, doseq=True)
                                st.markdown(f"""<div style="text-align: center;">
                                            <a href="?{url}" target="_blank" style="font-size: 16px; text-decoration: none;">
                                            Click to Open Details in New Tab</a></div>""", unsafe_allow_html=True)
                                del query_params['property_id']                          
                    idx += 1
        else:
            st.write('Sorry, No Properties Match the Selected Filters')
    else:
        table = query_params['role']
        column = table+'_id'
        query = f"SELECT name FROM {table} WHERE {column} = :1"
        cursor.execute(query, (query_params['username'], ))
        name = cursor.fetchone()

        st.markdown("""
            <style>
                .welcome-header {
                    text-align: center;
                    padding: 2rem 0;
                    background: linear-gradient(90deg, #1E1E1E, #2E2E2E);
                    border-radius: 10px;
                    margin-bottom: 2rem;
                }
                .feature-card {
                    background-color: #1E1E1E;
                    padding: 1.5rem;
                    border-radius: 10px;
                    margin-bottom: 1rem;
                    border: 1px solid #333;
                }
                .section-title {
                    color: #4CAF50;
                    font-size: 24px;
                    margin-bottom: 1rem;
                    text-align: center;
                }
            </style>
        """, unsafe_allow_html=True)

        st.markdown(f"""
            <div class="welcome-header">
                <h1 style='font-size: 2.5rem; margin-bottom: 1rem;'>Hello {name[0].split()[0]} ! 😊</h1>
                <h2 style='font-size: 2rem; margin-bottom: 1rem;'>Welcome to Property Management System</h2>
                <p style='font-size: 1.2rem; color: #aaa;'>Your one-stop solution for all real estate needs</p>
            </div>
        """, unsafe_allow_html=True)

        col1, col2, col3 = st.columns(3)

        with col1:
            st.markdown("""
                <div class="feature-card">
                    <h3 style='text-align: center; color: #4CAF50;'>🏠</h3>
                    <h3 style='text-align: center;'>Find Properties</h3>
                    <p style='text-align: center; color: #aaa;'>Browse through our extensive property collection</p>
                </div>
            """, unsafe_allow_html=True)

        with col2:
            st.markdown("""
                <div class="feature-card">
                    <h3 style='text-align: center; color: #4CAF50;'>💬</h3>
                    <h3 style='text-align: center;'>Direct Contact</h3>
                    <p style='text-align: center; color: #aaa;'>Connect directly with property owners</p>
                </div>
            """, unsafe_allow_html=True)

        with col3:
            st.markdown("""
                <div class="feature-card">
                    <h3 style='text-align: center; color: #4CAF50;'>✅</h3>
                    <h3 style='text-align: center;'>Verified Listings</h3>
                    <p style='text-align: center; color: #aaa;'>All properties are thoroughly verified</p>
                </div>
            """, unsafe_allow_html=True)

        st.markdown("""
            <div style="padding: 1rem; background-color: #1E1E1E; border-radius: 10px; margin-top: 1rem;">
                <h3 style='text-align: center; color: #4CAF50;'>📍 Start Your Search</h3>
                <p style='text-align: center;'>Use the side menu to find your dream property</p>
            </div>
        """, unsafe_allow_html=True)

        st.stop()

elif query_params['role'] == 'Seller':
    table = query_params['role']
    column = table+'_id'
    query = f"SELECT name FROM {table} WHERE {column} = :1"
    cursor.execute(query, (query_params['username'], ))
    name = cursor.fetchone()

    tab1, tab2 = st.tabs(["Upload New Property", "My Properties"])
    
    with tab1:
        st.header("List a New Property")
        
        with st.form("property_upload_form"):
            col1, col2 = st.columns(2)
            
            with col1:
                listing_title = st.text_input("Property Title", placeholder="Enter an attractive title")
                prop_type = st.selectbox("Property Type", ["Residential Property", "Commercial Property", "Plot/Land"])
                listing_type = st.selectbox("Listing Type", 
                    ["For Sale", "For Rent", "For Lease"] if prop_type != "Residential Property" 
                    else ["For Sale", "For Rent"])
                listing_price = st.number_input("Price (₹)", min_value=0, step=10000)
            
            with col2:
                df = pd.read_csv(r"D:\Projects\Property Management System\Frontend\Sub-Districts in India.csv")
                state = st.selectbox("State", df['State'].drop_duplicates().to_list())
                df_filtered = df[df['State'] == state]
                district = st.selectbox("District", df_filtered['District'].drop_duplicates().to_list())
                df_filtered = df_filtered[df_filtered['District'] == district]
                sub_district = st.selectbox("Sub-District", df_filtered['Sub-District'].to_list())
                
                street_address = st.text_input("Street Address", placeholder="Enter complete street address")
                full_address = f"{street_address}, {sub_district}, {district}, {state}"

            st.write("Property Description")
            listing_description = st.text_area("", placeholder="Describe your property in detail", height=100)
            
            st.write("Upload Property Photos (Maximum 5 photos)")
            uploaded_files = st.file_uploader("Choose files", type=['jpg', 'jpeg', 'png'], accept_multiple_files=True)
            
            st.write("Upload Proof of Ownership")
            ownership_doc = st.file_uploader("Upload document", type='pdf')
            
            submitted = st.form_submit_button("Submit Property Listing")
            
            if submitted:
                if not (listing_title and prop_type and listing_type and listing_price and 
                        full_address and listing_description and uploaded_files and ownership_doc):
                    st.error("Please fill all the required fields and upload necessary documents.")
                else:
                    try:        
                        cursor.execute("SELECT MAX(Property_Id) FROM Property")
                        max_prop_id = cursor.fetchone()[0]
                        new_prop_id = 1 if max_prop_id is None else max_prop_id + 1
                        
                        cursor.execute("SELECT MAX(Verification_Id) FROM Govt_Verification")
                        max_ver_id = cursor.fetchone()[0]
                        new_ver_id = 1 if max_ver_id is None else max_ver_id + 1
                        
                        cursor.execute("INSERT INTO Property VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9)",
                            [new_prop_id, full_address, prop_type, listing_title,
                            listing_type, listing_description, listing_price,
                            query_params['username'], new_ver_id])
                        
                        for idx, file in enumerate(uploaded_files[:5], 1):
                            cursor.execute("""
                                INSERT INTO Property_Photos (Property_Id, Photo_Id, Photo)
                                VALUES (:1, :2, :3)
                            """, [new_prop_id, idx, file.read()])
                        
                        cursor.execute("INSERT INTO Govt_Verification VALUES (:1, :2, :3, :4, :5)", 
                            [new_ver_id, new_prop_id, 0, None, ownership_doc.read()])
                        
                        cursor.execute('Select address from Property where Seller_Id=:1', [query_params['username']])
                        property_addresses = cursor.fetchall()
                        for address in property_addresses:
                            if full_address == address[0]:
                                st.error("This Property is already Listed under your Id")
                                conn.rollback()
                                break
                        else:
                            conn.commit()
                            st.success("Property listed successfully! It will be visible after verification.")
                        
                    except Exception as e:
                        conn.rollback()
                        st.error(f"An error occurred: {str(e)}")
    
    with tab2:
        st.header("My Properties")
        
        cursor.execute("""
            SELECT p.Property_Id, p.Listing_Title, p.Listing_Price, 
                p.Listing_Type, gv.Verification_Status, 
                COUNT(DISTINCT e.Enquiry_Id) as enquiry_count
            FROM Property p
            LEFT JOIN Govt_Verification gv ON p.Verification_Id = gv.Verification_Id
            LEFT JOIN Enquiry e ON p.Property_Id = e.Property_Id
            WHERE p.Seller_Id = :1
            GROUP BY p.Property_Id, p.Listing_Title, p.Listing_Price, 
                    p.Listing_Type, gv.Verification_Status
        """, [query_params['username']])
        
        properties = cursor.fetchall()
        
        if not properties:
            st.info("You haven't listed any properties yet.")
        else:
            for prop in properties:
                with st.expander(f"{prop[1]} - ₹{prop[2]:,}"):
                    col1, col2 = st.columns([1, 3])
                    with col1:
                        st.write(f"Listing Type: {prop[3]}")
                        st.write(f"Verification Status: {'Verified' if prop[4] == 1 else 'Pending Verification'}")
                    with col2:
                        st.write(f"Total Enquiries: {prop[5]}")
                        if st.button("View Enquiries", key=f"view_enq_{prop[0]}"):
                            st.session_state[f'viewing_enquiries_{prop[0]}'] = True

                        if st.session_state.get(f'viewing_enquiries_{prop[0]}', default=False):
                            cursor.execute("""
                                SELECT e.Enquiry_Id, e.Buyer_Id, e.Final_Amount, b.Name as Buyer_Name, b.Phone_No, b.Mail_Id
                                FROM Enquiry e
                                JOIN Buyer b ON e.Buyer_Id = b.Buyer_Id
                                WHERE e.Property_Id = :1
                                ORDER BY e.Enquiry_Id DESC
                            """, [prop[0]])
                            
                            enquiries = cursor.fetchall()
                            
                            if st.button("Close Enquiries", key=f"close_enq_{prop[0]}"):
                                st.session_state[f'viewing_enquiries_{prop[0]}'] = False
                                st.rerun()
                            
                            if not enquiries:
                                st.info("No enquiries received yet for this property.")
                            else:
                                for enq in enquiries:
                                    col1, col2 = st.columns([2, 1])
                                    
                                    with col1:
                                        st.subheader("Conversation History")
                                        cursor.execute("""
                                            SELECT Message, Time_Stamp, Sent_By, Buyer_Id, Seller_Id
                                            FROM Conversations 
                                            WHERE Enquiry_Id = :1 
                                            ORDER BY Time_Stamp
                                        """, [enq[0]])
                                        
                                        messages = cursor.fetchall()
                                        
                                        for msg in messages:
                                            if msg[2] == 'Buyer':
                                                st.markdown(f"""
                                                    <div style="text-align: left; margin-bottom: 10px;">
                                                        <div style="background-color: #1E1E1E; padding: 10px; 
                                                                border-radius: 10px; display: inline-block; max-width: 70%;">
                                                            <p style="margin: 0;">{msg[0]}</p>
                                                            <small style="color: #666;">
                                                                {msg[1].strftime('%d %b %Y, %H:%M')}
                                                            </small>
                                                        </div>
                                                    </div>
                                                """, unsafe_allow_html=True)
                                            else:
                                                st.markdown(f"""
                                                    <div style="text-align: right; margin-bottom: 10px;">
                                                        <div style="background-color: #2E7D32; padding: 10px; 
                                                                border-radius: 10px; display: inline-block; max-width: 70%;">
                                                            <p style="margin: 0;">{msg[0]}</p>
                                                            <small style="color: #DDD;">
                                                                {msg[1].strftime('%d %b %Y, %H:%M')}
                                                            </small>
                                                        </div>
                                                    </div>
                                                """, unsafe_allow_html=True)
                                        
                                        with st.form(key=f"msg_form_{enq[0]}", clear_on_submit=True):
                                            new_message = st.text_input("Type your reply", 
                                                                    key=f"msg_input_{enq[0]}")
                                            if st.form_submit_button("Send"):
                                                if new_message.strip():
                                                    try:
                                                        cursor.execute(
                                                            "SELECT MAX(Message_Id) FROM Conversations WHERE Enquiry_Id = :1",
                                                            [enq[0]]
                                                        )
                                                        max_msg_id = cursor.fetchone()[0]
                                                        next_msg_id = 1 if max_msg_id is None else max_msg_id + 1
                                                
                                                        cursor.execute("""
                                                            INSERT INTO Conversations (
                                                                Enquiry_Id, Message_Id, Seller_Id, Buyer_Id, 
                                                                Message, Time_Stamp, Sent_By
                                                            ) VALUES (
                                                                :1, :2, :3, :4, :5, CURRENT_TIMESTAMP, 'Seller'
                                                            )
                                                        """, [enq[0], next_msg_id, query_params['username'], 
                                                            enq[1], new_message])
                                                        
                                                        conn.commit()
                                                        st.rerun()
                                                    except Exception as e:
                                                        conn.rollback()
                                                        st.error(f"Error sending message: {str(e)}")
                                        cursor.execute("SELECT Message FROM Conversations WHERE Enquiry_Id = :1 ORDER BY Time_Stamp", [enq[0]])            
                                        msg = cursor.fetchall()
                                        if (f"I would like to proceed with the registration, Could you please confirm your acceptance to move forward. Property: {prop[1]} - Final Agreed Amount: ₹{enq[2]:,}",) in msg and ('Registration Request Accepted',) not in msg:
                                            reg = st.button("Accept Registration")
                                            cursor.execute("SELECT MAX(Message_Id) FROM Conversations WHERE Enquiry_Id = :1", [enq[0]])
                                            max_msg_id = cursor.fetchone()[0]
                                            next_msg_id = 1 if max_msg_id is None else max_msg_id + 1
                                            if reg:
                                                cursor.execute("""
                                                INSERT INTO Conversations (
                                                    Enquiry_Id, Message_Id, Buyer_Id, Seller_Id,
                                                    Message, Time_Stamp, Sent_By
                                                ) VALUES (
                                                    :1, :2, :3, :4, :5, CURRENT_TIMESTAMP, 'Seller'
                                                )
                                            """, [enq[0], next_msg_id, enq[1], 
                                                query_params['username'], 'Registration Request Accepted'])
                                                conn.commit()
                                                st.rerun()
                                
                                    with col2:
                                        st.subheader("Buyer Details")
                                        st.write(f"**Name:** {enq[3]}")
                                        st.write(f"**Phone:** {enq[4]}")
                                        st.write(f"**Email:** {enq[5]}")
                                        st.write(f"**Offered Amount:** ₹{enq[2]:,}")

elif query_params['role'] == 'Admin':
    st.title("Admin Dashboard")

    tabs = st.tabs(["Property Verifications", "Registration Requests", "Payments"])
    
    with tabs[0]:
        st.subheader("Pending Property Verifications")
        
        cursor.execute("""
            SELECT p.Property_Id, p.Listing_Title, p.Address, s.Name as Seller_Name, 
                p.Listing_Type, p.Listing_Price, gv.Verification_Id
            FROM Property p
            JOIN Seller s ON p.Seller_Id = s.Seller_Id
            JOIN Govt_Verification gv ON p.Verification_Id = gv.Verification_Id
            WHERE gv.Verification_Status = 0
            ORDER BY p.Property_Id DESC
        """)
        pending_verifications = cursor.fetchall()
        
        if not pending_verifications:
            st.info("No pending verifications")
        else:
            for prop in pending_verifications:
                with st.expander(f"Property ID: {prop[0]} - {prop[1]}"):
                    col1, col2 = st.columns([2, 1])
                    
                    with col1:
                        st.write(f"**Address:** {prop[2]}")
                        st.write(f"**Seller:** {prop[3]}")
                        st.write(f"**Type:** {prop[4]}")
                        st.write(f"**Price:** ₹{prop[5]:,}")
                        
                        # Get ownership document
                        cursor.execute("""
                            SELECT Proof_Of_Ownership 
                            FROM Govt_Verification 
                            WHERE Verification_Id = :1
                        """, [prop[6]])
                        doc = cursor.fetchone()[0].read()
                        
                        st.download_button(
                            "Download Ownership Document",
                            doc,
                            file_name=f"ownership_doc_{prop[0]}.pdf",
                            mime="application/pdf"
                        )
                    
                    with col2:
                        if st.button("Approve", key=f"approve_{prop[0]}"):
                            try:
                                cursor.execute("""
                                    UPDATE Govt_Verification 
                                    SET Verification_Status = 1, 
                                        Verification_Date = CURRENT_DATE
                                    WHERE Verification_Id = :1
                                """, [prop[6]])
                                conn.commit()
                                st.success("Property verified successfully!")
                                st.rerun()
                            except Exception as e:
                                conn.rollback()
                                st.error(f"Error: {str(e)}")
                        
                        if st.button("Reject", key=f"reject_{prop[0]}"):
                            try:
                                cursor.execute("""
                                    DELETE FROM Property_Photos 
                                    WHERE Property_Id = :1
                                """, [prop[0]])
                                
                                cursor.execute("""
                                    DELETE FROM Govt_Verification 
                                    WHERE Verification_Id = :1
                                """, [prop[6]])
                                
                                cursor.execute("""
                                    DELETE FROM Property 
                                    WHERE Property_Id = :1
                                """, [prop[0]])
                                
                                conn.commit()
                                st.success("Property listing rejected and removed.")
                                st.rerun()
                            except Exception as e:
                                conn.rollback()
                                st.error(f"Error: {str(e)}")
    with tabs[1]:
        st.subheader("Registration Requests")
        
        cursor.execute("""
            SELECT DISTINCT
                p.Property_Id,
                p.Listing_Title,
                b.Name as Buyer_Name,
                s.Name as Seller_Name,
                e.Final_Amount,
                e.Enquiry_Id,
                CASE 
                    WHEN EXISTS (
                        SELECT 1 
                        FROM Conversations c2 
                        WHERE c2.Enquiry_Id = e.Enquiry_Id 
                        AND c2.Message = 'Registration Request Accepted'
                        AND c2.Sent_By = 'Seller'
                    ) THEN 'Accepted'
                    ELSE 'Pending'
                END as Status,
                CASE 
                    WHEN EXISTS (
                        SELECT 1 FROM Payment p WHERE p.Enquiry_Id = e.Enquiry_Id
                    ) THEN 'Payment Done'
                    ELSE 'Payment Pending'
                END as Payment_Status,
                CASE 
                    WHEN EXISTS (
                        SELECT 1 
                        FROM Payment p 
                        JOIN Registrations r ON p.Payment_Id = r.Payment_Id 
                        WHERE p.Enquiry_Id = e.Enquiry_Id
                    ) THEN 'Registered'
                    ELSE 'Not Registered'
                END as Registration_Status,
                b.Phone_No,
                s.Phone_No
            FROM Property p
            JOIN Enquiry e ON p.Property_Id = e.Property_Id
            JOIN Buyer b ON e.Buyer_Id = b.Buyer_Id
            JOIN Seller s ON e.Seller_Id = s.Seller_Id
            JOIN Conversations c ON e.Enquiry_Id = c.Enquiry_Id
            WHERE c.Message LIKE 'I would like to proceed with the registration, Could you please confirm your acceptance to move forward. Property: %'
            ORDER BY e.Enquiry_Id DESC
        """)
        
        registration_requests = cursor.fetchall()
        
        if not registration_requests:
            st.info("No registration requests found")
        else:
            for req in registration_requests:
                with st.expander(f"{req[1]} - {req[2]} (Buyer) & {req[3]} (Seller)"):
                    st.write(f"**Property ID:** {req[0]}")
                    st.write(f"**Buyer Contact No:** {req[9]}")
                    st.write(f"**Seller Contact No:** {req[10]}")
                    st.write(f"**Agreed Amount:** ₹{req[4]:,}")
                    st.write(f"**Status:** {req[6]}")
                    st.write(f"**Payment Status:** {req[7]}")
                    st.write(f"**Registration Status:** {req[8]}")
                    
                    if req[6] == 'Accepted' and req[7] == 'Payment Pending':
                        payment_col1, payment_col2 = st.columns(2)
                        with payment_col1:
                            payment_mode = st.selectbox(
                                "Payment Mode",
                                ["Bank Transfer", "Check", "Cash"],
                                key=f"payment_mode_{req[5]}"
                            )
                        with payment_col2:
                            transaction_id = st.text_input(
                                "Transaction ID",
                                key=f"transaction_id_{req[5]}"
                            )
                        
                        if st.button("Record Payment", key=f"record_payment_{req[5]}"):
                            try:
                                # Get next Payment_Id
                                cursor.execute("SELECT MAX(Payment_Id) FROM Payment")
                                next_payment_id = (cursor.fetchone()[0] or 0) + 1
                                
                                cursor.execute("""
                                    INSERT INTO Payment (
                                        Payment_Id, Enquiry_Id, Payment_Mode, Transaction_Id
                                    ) VALUES (
                                        :1, :2, :3, :4
                                    )
                                """, [next_payment_id, req[5], payment_mode, transaction_id])
                                
                                conn.commit()
                                st.success("Payment recorded successfully!")
                                st.rerun()
                            except Exception as e:
                                conn.rollback()
                                st.error(f"Error recording payment: {str(e)}")
                    
                    elif req[7] == 'Payment Done' and req[8] == 'Not Registered':
                        # Get registration offices
                        cursor.execute("SELECT Reg_Off_Id, Office_Name FROM Registration_Offices")
                        offices = cursor.fetchall()
                        
                        office_id = st.selectbox(
                            "Select Registration Office",
                            options=[o[0] for o in offices],
                            format_func=lambda x: next(o[1] for o in offices if o[0] == x),
                            key=f"office_{req[5]}"
                        )
                        
                        doc_number = st.text_input(
                            "Document Number",
                            key=f"doc_number_{req[5]}"
                        )
                        
                        if st.button("Complete Registration", key=f"complete_reg_{req[5]}"):
                            try:
                                # Get Payment_Id
                                cursor.execute("SELECT Payment_Id FROM Payment WHERE Enquiry_Id = :1", [req[5]])
                                payment_id = cursor.fetchone()[0]
                                
                                # Get next Registration_Id
                                cursor.execute("SELECT MAX(Registration_Id) FROM Registrations")
                                next_reg_id = (cursor.fetchone()[0] or 0) + 1
                                
                                cursor.execute("""
                                    INSERT INTO Registrations (
                                        Registration_Id, Payment_Id, Reg_Off_Id, Document_Number
                                    ) VALUES (
                                        :1, :2, :3, :4
                                    )
                                """, [next_reg_id, payment_id, office_id, doc_number])
                                
                                # Update property status
                                cursor.execute("""
                                    UPDATE Property 
                                    SET Type = 'Sold' 
                                    WHERE Property_Id = :1
                                """, [req[0]])
                                
                                conn.commit()
                                st.success("Registration completed successfully!")
                                st.rerun()
                            except Exception as e:
                                conn.rollback()
                                st.error(f"Error completing registration: {str(e)}")
    
    with tabs[2]:
        st.subheader("Payment Records")
        
        cursor.execute("""
            SELECT 
                p.Property_Id,
                p.Listing_Title,
                b.Name as Buyer_Name,
                s.Name as Seller_Name,
                e.Final_Amount,
                pay.Payment_Mode,
                pay.Transaction_Id,
                r.Document_Number,
                ro.Office_Name
            FROM Payment pay
            JOIN Enquiry e ON pay.Enquiry_Id = e.Enquiry_Id
            JOIN Property p ON e.Property_Id = p.Property_Id
            JOIN Buyer b ON e.Buyer_Id = b.Buyer_Id
            JOIN Seller s ON e.Seller_Id = s.Seller_Id
            LEFT JOIN Registrations r ON pay.Payment_Id = r.Payment_Id
            LEFT JOIN Registration_Offices ro ON r.Reg_Off_Id = ro.Reg_Off_Id
            ORDER BY pay.Payment_Id DESC
        """)
        
        payments = cursor.fetchall()
        
        if not payments:
            st.info("No payment records found")
        else:
            for payment in payments:
                with st.expander(f"{payment[1]} - {payment[2]} & {payment[3]}"):
                    col1, col2 = st.columns(2)
                    
                    with col1:
                        st.write(f"**Property ID:** {payment[0]}")
                        st.write(f"**Amount:** ₹{payment[4]:,}")
                        st.write(f"**Payment Mode:** {payment[5]}")
                        st.write(f"**Transaction ID:** {payment[6]}")
                    
                    with col2:
                        if payment[7]:  # If registration exists
                            st.write("**Registration Status:** Complete")
                            st.write(f"**Document Number:** {payment[7]}")
                            st.write(f"**Registration Office:** {payment[8]}")
                        else:
                            st.write("**Registration Status:** Pending")