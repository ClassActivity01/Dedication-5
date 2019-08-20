CREATE Database Proteus
GO

USE Proteus
GO

CREATE TABLE VAT
(
    [Date]                     		datetime NOT NULL,
    VAT_Rate                 		float NOT NULL,
    CONSTRAINT VAT_PK PRIMARY KEY NONCLUSTERED ([Date])
)

CREATE TABLE Gender
(
    Gender_ID                		varchar(1) NOT NULL,
    Gender_Name              		varchar(6) NOT NULL,
    CONSTRAINT Gender_PK PRIMARY KEY NONCLUSTERED (Gender_ID)
)

CREATE TABLE Production_Schedule
(
    Production_Schedule_ID   		integer NOT NULL,
    Production_Schedule_Date 		datetime NOT NULL,
	intervals						integer NOT NULL,
    CONSTRAINT Production_Schedule_PK PRIMARY KEY NONCLUSTERED (Production_Schedule_ID)
)

CREATE TABLE Audit_Type
(
    Audit_Type_ID            		integer NOT NULL,
    Name          					varchar(6) NOT NULL,
    [Description]   				varchar(255) NOT NULL,
    CONSTRAINT Audit_Type_PK PRIMARY KEY NONCLUSTERED (Audit_Type_ID)
)

CREATE TABLE Job_Card_Status
(
    Job_Card_Status_ID       		integer NOT NULL,
    Name     						varchar(25) NOT NULL,
    [Description] 					varchar(250) NOT NULL,
    CONSTRAINT Job_Card_Status_PK PRIMARY KEY NONCLUSTERED (Job_Card_Status_ID)
)

CREATE TABLE Part_Status
(
    Part_Status_ID           		integer NOT NULL,
    Name         					varchar(25) NOT NULL,
    [Description]  					varchar(250) NOT NULL,
    CONSTRAINT Part_Status_PK PRIMARY KEY NONCLUSTERED (Part_Status_ID)
)

CREATE TABLE Invoice_Status
(
    Invoice_Status_ID        		integer NOT NULL,
    Name      						varchar(15) NOT NULL,
    Description 					varchar(255) NOT NULL,
    CONSTRAINT Invoice_Status_PK PRIMARY KEY NONCLUSTERED (Invoice_Status_ID)
)

CREATE TABLE Job_Card_Priority
(
    Job_Card_Priority_ID     		integer NOT NULL,
    Name   							varchar(15) NOT NULL,
    Description 					varchar(255) NOT NULL,
    CONSTRAINT Job_Card_Priority_PK PRIMARY KEY NONCLUSTERED (Job_Card_Priority_ID)
)

CREATE TABLE Supplier_Order_Status
(
    Supplier_Order_Status_ID 		integer NOT NULL,
    Name 							varchar(30) NOT NULL,
    Description 					varchar(255) NOT NULL,
    CONSTRAINT Supplier_Order_Status_PK PRIMARY KEY NONCLUSTERED (Supplier_Order_Status_ID)
)

CREATE TABLE Delivery_Method
(
    Delivery_Method_ID       		integer NOT NULL,
    Name     						varchar(20) NOT NULL,
    Description 					varchar(255) NOT NULL,
    CONSTRAINT Delivery_Method_PK PRIMARY KEY NONCLUSTERED (Delivery_Method_ID)
)

CREATE TABLE Client_Order_Type
(
    Client_Order_Type_ID     	integer NOT NULL,
    Type        				varchar(15) NOT NULL,
    Description 				varchar(255) NOT NULL,
    CONSTRAINT Client_Order_Type_PK PRIMARY KEY NONCLUSTERED (Client_Order_Type_ID)
)

CREATE TABLE Client_Order_Status
(
    Client_Order_Status_ID   	integer NOT NULL,
    Name 						varchar(30) NOT NULL,
    Description 				varchar(255) NOT NULL,
    CONSTRAINT Client_Order_Status_PK PRIMARY KEY NONCLUSTERED (Client_Order_Status_ID)
)

CREATE TABLE Machine_Status
(
    Machine_Status_ID        	integer NOT NULL,
    Name      					varchar(20) NOT NULL,
    Description 				varchar(255) NOT NULL,
    CONSTRAINT Machine_Status_PK PRIMARY KEY NONCLUSTERED (Machine_Status_ID)
)

CREATE TABLE Employee_Type
(
    Employee_Type_ID         	integer NOT NULL,
    Name       					varchar(30) NOT NULL,
    Description 				varchar(255) NOT NULL,
    CONSTRAINT Employee_Type_PK PRIMARY KEY NONCLUSTERED (Employee_Type_ID)
)

CREATE TABLE Machine
(
    Machine_ID               	integer NOT NULL,
    Name             			varchar(40) NOT NULL,
    Manufacturer     			varchar(40) NOT NULL,
    Model            			varchar(40) NOT NULL,
    Price_Per_Hour   			money NOT NULL,
    Run_Time         			integer NOT NULL,
    CONSTRAINT Machine_PK PRIMARY KEY NONCLUSTERED (Machine_ID)
)

CREATE TABLE Raw_Material
(
    Name        						varchar(25) NOT NULL,
    Description 						varchar(250) NOT NULL,
    Minimum_Stock_Instances 			integer NOT NULL,
    Raw_Material_ID          			integer NOT NULL,
    CONSTRAINT Raw_Material_PK PRIMARY KEY NONCLUSTERED (Raw_Material_ID)
)

CREATE TABLE Manual_Labour_Type
(
    Manual_Labour_Type_ID    			integer NOT NULL,
    Name  								varchar(25) NOT NULL,
    Description 						varchar(250) NOT NULL,
    Duration 							integer NOT NULL,
    Sub_Contractor           			bit NOT NULL,
    CONSTRAINT Manual_Labour_Type_PK PRIMARY KEY NONCLUSTERED (Manual_Labour_Type_ID)
)

CREATE TABLE Part_Type
(
    Part_Type_ID             			integer NOT NULL,
    Abbreviation   						varchar(10) NOT NULL,
    Name           						varchar(50) NOT NULL,
    Description    						varchar(250) NOT NULL,
    Selling_Price  						money NOT NULL,
    Dimension      						varchar(40) NOT NULL,
    Minimum_Level  						integer NOT NULL,
    Maximum_Level  						integer NOT NULL,
    Max_Discount_Rate 					integer NOT NULL,
    Manufactured             			bit NOT NULL,
    Average_Completion_Time  			integer NOT NULL,
	Number_Of_Stages					integer NOT NULL,
    CONSTRAINT Part_Type_PK PRIMARY KEY NONCLUSTERED (Part_Type_ID)
)

CREATE TABLE Unique_Machine
(
    Unique_Machine_ID        			integer NOT NULL,
	Unique_Machine_Serial    			varchar(25) NOT NULL,
    Machine_Status_ID        			integer NOT NULL,
    Machine_ID               			integer NOT NULL,
    CONSTRAINT Unique_Machine_PK PRIMARY KEY NONCLUSTERED (Unique_Machine_ID),
     FOREIGN KEY (Machine_Status_ID) REFERENCES Machine_Status(Machine_Status_ID),
     FOREIGN KEY (Machine_ID) REFERENCES Machine(Machine_ID)
)

CREATE TABLE Part_Blueprint
(
    Blueprint_ID             integer NOT NULL,
    Name           			varchar(100) NOT NULL,
    File_Type      			varchar(6) NOT NULL,
    location       			varchar(255) NOT NULL,
    Part_Type_ID             integer NOT NULL,
    CONSTRAINT Part_Blueprint_PK PRIMARY KEY NONCLUSTERED (Blueprint_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE [Audit]
(
    Audit_ID                 			integer identity(1,1),
    [Table]              				varchar(40) NOT NULL,
    [Date]               				datetime NOT NULL,
    Employee_ID              			int NOT NULL,
    Employee_Name            			varchar(70) NOT NULL,
    Audit_Type_ID            			integer NOT NULL,
    CONSTRAINT Audit_1_PK PRIMARY KEY NONCLUSTERED (Audit_ID),
	 FOREIGN KEY (Audit_Type_ID) REFERENCES Audit_Type(Audit_Type_ID)
)

CREATE TABLE Manual_Labour_Type_Part
(
    Stage_In_Manufacturing   			integer NOT NULL,
    Manual_Labour_Type_ID    			integer NOT NULL,
    Part_Type_ID             			integer NOT NULL,
    CONSTRAINT Manual_Labour_Type_Part_PK
    PRIMARY KEY NONCLUSTERED (Manual_Labour_Type_ID,Part_Type_ID),
     FOREIGN KEY (Manual_Labour_Type_ID) REFERENCES Manual_Labour_Type(Manual_Labour_Type_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Job_Card
(
    Job_Card_ID              			integer NOT NULL,
    Job_Card_Date            			datetime NOT NULL,
    Job_Card_Status_ID       			integer NOT NULL,
    Job_Card_Priority_ID     			integer NOT NULL,
    CONSTRAINT Job_Card_PK PRIMARY KEY NONCLUSTERED (Job_Card_ID),
     FOREIGN KEY (Job_Card_Status_ID) REFERENCES Job_Card_Status(Job_Card_Status_ID),
     FOREIGN KEY (Job_Card_Priority_ID) REFERENCES Job_Card_Priority(Job_Card_Priority_ID)
)

CREATE TABLE Machine_Part
(
    Stage_In_Manufacturing   			integer NOT NULL,
    Machine_ID               			integer NOT NULL,
    Part_Type_ID             			integer NOT NULL,
    CONSTRAINT Machine_Part_PK PRIMARY KEY NONCLUSTERED (Machine_ID,Part_Type_ID),
     FOREIGN KEY (Machine_ID) REFERENCES Machine(Machine_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Employee
(
    Employee_ID              			int NOT NULL,
    Name                 				varchar(35) NOT NULL,
    Surname              				varchar(35) NOT NULL,
    ID_Number            	 			varchar(13),
    Contact_Number       	 			varchar(15) NOT NULL,
    Password              	 			varchar(64) NOT NULL,
    Salt        		 	 			varchar(10) NOT NULL,
    Username             	 			varchar(20) NOT NULL,
	Email             	 	 			varchar(254),
    Employee_Type_ID         			integer NOT NULL,
    Gender_ID                			varchar(1) NOT NULL,
    Employee_Status          			bit NOT NULL,
    CONSTRAINT Employee_PK PRIMARY KEY NONCLUSTERED (Employee_ID),
     FOREIGN KEY (Employee_Type_ID) REFERENCES Employee_Type(Employee_Type_ID),
     FOREIGN KEY (Gender_ID) REFERENCES Gender(Gender_ID)
)

CREATE TABLE Province
(
    Province_ID              			integer NOT NULL,
    Province            				varchar(13) NOT NULL,
    CONSTRAINT Province_PK PRIMARY KEY NONCLUSTERED (Province_ID)
)

CREATE TABLE Machine_Employee
(
    Employee_ID              			int NOT NULL,
    Machine_ID               			integer NOT NULL,
    CONSTRAINT Machine_Employee_PK PRIMARY KEY NONCLUSTERED (Employee_ID,Machine_ID),
     FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
     FOREIGN KEY (Machine_ID) REFERENCES Machine(Machine_ID)
)

CREATE TABLE Audit_Detail
(
    Details_ID               			integer identity(1,1),
    Field                    			varchar(50),
    [Value]                  			varchar(500),
    Record_ID                			integer NOT NULL,
    Audit_ID                 			integer NOT NULL,
    CONSTRAINT Audit_Details_PK PRIMARY KEY NONCLUSTERED (Details_ID),
     FOREIGN KEY (Audit_ID) REFERENCES Audit(Audit_ID)
)

CREATE TABLE Manual_Labour_Employee
(
    Manual_Labour_Type_ID    			integer NOT NULL,
    Employee_ID              			int NOT NULL,
    CONSTRAINT Manual_Labour_Employee_PK PRIMARY KEY NONCLUSTERED (Employee_ID,Manual_Labour_Type_ID),
     FOREIGN KEY (Manual_Labour_Type_ID) REFERENCES Manual_Labour_Type(Manual_Labour_Type_ID),
     FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
)

CREATE TABLE Sub_Contractor
(
    Sub_Contractor_ID        			integer NOT NULL,
    Name      							varchar(40) NOT NULL,
    [Address]   						varchar(95) NOT NULL,
    City      							varchar(35) NOT NULL,
    Zip       							varchar(4) NOT NULL,
    [Status]    						bit NOT NULL,
    Manual_Labour_Type_ID    			integer NOT NULL,
    Province_ID              			integer NOT NULL,
    CONSTRAINT Sub_Contractor_PK PRIMARY KEY NONCLUSTERED (Sub_Contractor_ID),
     FOREIGN KEY (Manual_Labour_Type_ID) REFERENCES Manual_Labour_Type(Manual_Labour_Type_ID),
     FOREIGN KEY (Province_ID) REFERENCES Province(Province_ID)
)

CREATE TABLE Audit_Update_Detail
(
    Update_Detail_ID         			integer identity(1,1),
    Update_Field       					varchar(50),
    New_Value          					varchar(500),
    Old_Value          					varchar(500),
    Record_ID                			integer NOT NULL,
    Audit_ID                 			integer NOT NULL,
    CONSTRAINT Audit_Update_Detail_PK PRIMARY KEY NONCLUSTERED (Update_Detail_ID),
     FOREIGN KEY (Audit_ID) REFERENCES Audit(Audit_ID)
)

CREATE TABLE Job_Card_Detail
(
    Job_Card_Details_ID      			integer NOT NULL,
    Quantity                 			integer NOT NULL,
    Non_Manual               			bit NOT NULL,
    Job_Card_ID              			integer NOT NULL,
    Part_Type_ID             			integer NOT NULL,
    CONSTRAINT Job_Card_Details_PK PRIMARY KEY NONCLUSTERED (Job_Card_Details_ID),
     FOREIGN KEY (Job_Card_ID) REFERENCES Job_Card(Job_Card_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Client
(
    Client_ID               			integer NOT NULL,
    Name              					varchar(35) NOT NULL,
    [Address]           				varchar(95) NOT NULL,
    City              					varchar(35) NOT NULL,
    Zip               					varchar(4) NOT NULL,
    Overdue_Payment          			money NOT NULL,
    Vat_Number               			varchar(12) NOT NULL,
    Account_Name             			varchar(20) NOT NULL,
    Contract_Discount_Rate   			float NOT NULL,
    Client_Status            			bit NOT NULL,
    Province_ID              			integer NOT NULL,
    Settlement_Discount_Rate 			float NOT NULL,
    CONSTRAINT Client_PK PRIMARY KEY NONCLUSTERED (Client_ID),
     FOREIGN KEY (Province_ID) REFERENCES Province(Province_ID)
)

CREATE TABLE Supplier
(
    Supplier_ID             			integer NOT NULL,
    Name            					varchar(40) NOT NULL,
    [Address]         					varchar(95) NOT NULL,
    City            					varchar(35) NOT NULL,
    Zip             					varchar(4) NOT NULL,
    Bank_Account_Number 				varchar(20) NOT NULL,
    Bank_Branch     					varchar(6) NOT NULL,
    Bank_Name       					varchar(35) NOT NULL,
    Email           					varchar(254) NOT NULL,
    Contact_Number  					varchar(15) NOT NULL,
    [Status]          					bit NOT NULL,
    Province_ID              			integer NOT NULL,
	Bank_Reference						varchar(20) NOT NULL,
	Contact_Name						varchar(70) NOT NULL,
	Foreign_Bank						bit NOT NULL,
    CONSTRAINT Supplier_PK PRIMARY KEY NONCLUSTERED (Supplier_ID),
     FOREIGN KEY (Province_ID) REFERENCES Province(Province_ID)
)

CREATE TABLE Part_Supplier
(
    Is_Prefered              			bit NOT NULL,
    Supplier_ID              			integer NOT NULL,
    Part_Type_ID             			integer NOT NULL,
    unit_price               			money NOT NULL,
    CONSTRAINT Part_Supplier_PK
    PRIMARY KEY NONCLUSTERED (Supplier_ID,Part_Type_ID),
     FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Raw_Material_Supplier
(
    Raw_Material_ID          			integer NOT NULL,
    Supplier_ID              			integer NOT NULL,
    Is_Prefered              			bit NOT NULL,
    unit_price               			money NOT NULL,
    CONSTRAINT Raw_Material_Supplier_PK PRIMARY KEY NONCLUSTERED (Raw_Material_ID,Supplier_ID),
     FOREIGN KEY (Raw_Material_ID) REFERENCES Raw_Material(Raw_Material_ID),
     FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
)

CREATE TABLE Supplier_Quote
(
    Supplier_Quote_ID        			integer NOT NULL,
	Supplier_Quote_Serial 	 			varchar(10) NOT NULL,
    Supplier_Quote_Date      			datetime NOT NULL,
    Supplier_ID              			integer NOT NULL,
	Supplier_Quote_Expiry_Date 			datetime NOT NULL,
    CONSTRAINT Supplier_Quote_PK PRIMARY KEY NONCLUSTERED (Supplier_Quote_ID),
     FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
)

CREATE TABLE Client_Discount_Rate
(
    Client_ID                			integer NOT NULL,
    Discount_Rate     					float NOT NULL,
    Part_Type_ID             			integer NOT NULL,
    CONSTRAINT Client_Discount_Rate_PK PRIMARY KEY NONCLUSTERED (Client_ID,Part_Type_ID),
     FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Supplier_Order
(
    Supplier_Order_ID        			integer NOT NULL,
    [Date]      						datetime NOT NULL,
    Supplier_ID              			integer NOT NULL,
    Supplier_Order_Status_ID 			integer NOT NULL,
    CONSTRAINT Supplier_Order_PK PRIMARY KEY NONCLUSTERED (Supplier_Order_ID),
     FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
     FOREIGN KEY (Supplier_Order_Status_ID) REFERENCES Supplier_Order_Status(Supplier_Order_Status_ID)
)

CREATE TABLE Client_Contact_Person_Detail
(
    Contact_ID              			integer NOT NULL,
    Number           					varchar(15) NOT NULL,
    Name             					varchar(70) NOT NULL,
    Job_Description         			varchar(255) NOT NULL,
    Email_Address            			varchar(254) NOT NULL,
    Client_ID                			integer NOT NULL,
    CONSTRAINT Client_Contact_Number_PK PRIMARY KEY NONCLUSTERED (Contact_ID),
     FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID)
)

CREATE TABLE Sub_Contractor_Contact_Detail
(
    Contact_ID							integer NOT NULL,
	Sub_Contractor_ID        			integer NOT NULL,
    Number 								varchar(15) NOT NULL,
    Name 								varchar(70) NOT NULL,
    Email     							varchar(254) NOT NULL,
    CONSTRAINT Sub_Contractor_Contact_Details_PK PRIMARY KEY NONCLUSTERED (Contact_ID),
     FOREIGN KEY (Sub_Contractor_ID) REFERENCES Sub_Contractor(Sub_Contractor_ID)
)

CREATE TABLE Component
(
    Component_ID             			integer NOT NULL,
    Quantity       						integer NOT NULL,
    Unit_Price     						money NOT NULL,
    [Description]    					varchar(250) NOT NULL,
    Dimension      						varchar(40) NOT NULL,
    Name           						varchar(35) NOT NULL,
	Min_Stock							integer NOT NULL,
    CONSTRAINT Set_Part_PK PRIMARY KEY NONCLUSTERED (Component_ID)
)

CREATE TABLE Client_Order
(
    Client_Order_ID          			integer NOT NULL,
    [Date]       						datetime NOT NULL,
    Reference_ID             			varchar(10) NOT NULL,
    Contact_ID               			integer NOT NULL,
    Client_ID                			integer NOT NULL,
    Settlement_Discount_Rate 			float NOT NULL,
    Client_Order_Type_ID     			integer NOT NULL,
    Client_Order_Status_ID   			integer NOT NULL,
    Delivery_Method_ID       			integer NOT NULL,
    Job_Card_ID              			integer NOT NULL,
    VAT_Inclu                			bit NOT NULL,
	[Comment]                  			varchar(500),
    CONSTRAINT Client_Order_PK PRIMARY KEY NONCLUSTERED (Client_Order_ID),
     FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID),
     FOREIGN KEY (Client_Order_Type_ID) REFERENCES Client_Order_Type(Client_Order_Type_ID),
     FOREIGN KEY (Client_Order_Status_ID) REFERENCES Client_Order_Status(Client_Order_Status_ID),
     FOREIGN KEY (Delivery_Method_ID) REFERENCES Delivery_Method(Delivery_Method_ID),
     FOREIGN KEY (Job_Card_ID) REFERENCES Job_Card(Job_Card_ID)
)

CREATE TABLE Supplier_Order_Quote
(
    Supplier_Quote_ID        			integer NOT NULL,
    Supplier_Order_ID        			integer NOT NULL,
    CONSTRAINT Supplier_Order_Quote_PK PRIMARY KEY NONCLUSTERED (Supplier_Quote_ID),
     FOREIGN KEY (Supplier_Quote_ID) REFERENCES Supplier_Quote(Supplier_Quote_ID),
     FOREIGN KEY (Supplier_Order_ID) REFERENCES Supplier_Order(Supplier_Order_ID)
)

CREATE TABLE Supplier_Quote_Component
(
    Supplier_Quote_ID        			integer NOT NULL,
    Component_ID             			integer NOT NULL,
    Quantity_Requested       			integer NOT NULL,
    Price                    			money NOT NULL,
    CONSTRAINT Supplier_Quote_Component_PK PRIMARY KEY NONCLUSTERED (Supplier_Quote_ID,Component_ID),
     FOREIGN KEY (Supplier_Quote_ID) REFERENCES Supplier_Quote(Supplier_Quote_ID),
     FOREIGN KEY (Component_ID) REFERENCES Component(Component_ID)
)

CREATE TABLE Client_Quote
(
    Client_Quote_ID          			integer NOT NULL,
    [Date]        						datetime NOT NULL,
    Client_ID                			integer NOT NULL,
    Contact_ID               			integer NOT NULL,
	Client_Quote_Expiry_Date			datetime NOT NULL,
    CONSTRAINT Client_Quote_PK PRIMARY KEY NONCLUSTERED (Client_Quote_ID),
     FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID),
     FOREIGN KEY (Contact_ID) REFERENCES Client_Contact_Person_Detail(Contact_ID)
)

CREATE TABLE Contracted_Client_Orders
(
    Contract_Client_Order_ID	integer,
	Client_Order_ID          integer NOT NULL,
    Mine_Name                varchar(40) NOT NULL,
    Contract_Discount_Rate   float NOT NULL,
	CONSTRAINT Contract_Client_Order_ID_PK PRIMARY KEY NONCLUSTERED (Contract_Client_Order_ID),    
	 FOREIGN KEY (Client_Order_ID) REFERENCES Client_Order(Client_Order_ID)
)

CREATE TABLE Supplier_Quote_Detail_Part
(
    Supplier_Quote_ID        		integer NOT NULL,
    Quantity  						integer NOT NULL,
    Price     						money NOT NULL,
    Part_Type_ID             		integer NOT NULL,
    CONSTRAINT Supplier_Quote_Detail_Part_PK PRIMARY KEY NONCLUSTERED (Supplier_Quote_ID,Part_Type_ID),
     FOREIGN KEY (Supplier_Quote_ID) REFERENCES Supplier_Quote(Supplier_Quote_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Delivery_Note
(
    Delivery_Note_ID         		integer NOT NULL,
    Delivery_Note_Date       		datetime NOT NULL,
    Client_Order_ID          		integer NOT NULL,
    CONSTRAINT Delivery_Note_PK PRIMARY KEY NONCLUSTERED (Delivery_Note_ID),
     FOREIGN KEY (Client_Order_ID) REFERENCES Client_Order(Client_Order_ID)
)

CREATE TABLE Supplier_Order_Detail_Part
(
    Quantity  						integer NOT NULL,
    Price     						money NOT NULL,
    Quantity_Received        		integer NOT NULL,
    Part_Type_ID             		integer NOT NULL,
    Supplier_Order_ID        		integer NOT NULL,
    CONSTRAINT Supplier_Order_Detail_Part_PK PRIMARY KEY NONCLUSTERED (Supplier_Order_ID,Part_Type_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID),
     FOREIGN KEY (Supplier_Order_ID) REFERENCES Supplier_Order(Supplier_Order_ID)
)

CREATE TABLE Supplier_Quote_Detail_Raw_Material
(
    Supplier_Quote_ID        		integer NOT NULL,
    Raw_Material_ID          		integer NOT NULL,
    Quantity      					integer NOT NULL,
    Price     						money NOT NULL,
	Dimension						varchar(40) NOT NULL,
    CONSTRAINT Supplier_Quote_Detail_Raw_Material_PK PRIMARY KEY NONCLUSTERED (Supplier_Quote_ID,Raw_Material_ID),
     FOREIGN KEY (Supplier_Quote_ID) REFERENCES Supplier_Quote(Supplier_Quote_ID),
     FOREIGN KEY (Raw_Material_ID) REFERENCES Raw_Material(Raw_Material_ID)
)

CREATE TABLE Client_Order_Detail
(
    Client_Order_Detail_ID   		integer NOT NULL,
    Quantity                 		integer NOT NULL,
    Quantity_Delivered         		integer NOT NULL,
    Part_Price               		money NOT NULL,
    Client_Discount_Rate     		float NOT NULL,
    Client_Order_ID          		integer NOT NULL,
    Part_Type_ID             		integer NOT NULL,
    CONSTRAINT Client_Order_Detail_PK PRIMARY KEY NONCLUSTERED (Client_Order_Detail_ID),
     FOREIGN KEY (Client_Order_ID) REFERENCES Client_Order(Client_Order_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Supplier_Order_Component
(
    Component_ID             		integer NOT NULL,
    Quantity_Requested       		integer NOT NULL,
    Quantity_Received        		integer NOT NULL,
    Price                    		money NOT NULL,
    Supplier_Order_ID        		integer NOT NULL,
    CONSTRAINT Supplier_Order_Component_PK PRIMARY KEY NONCLUSTERED (Component_ID,Supplier_Order_ID),
     FOREIGN KEY (Component_ID) REFERENCES Component(Component_ID),
     FOREIGN KEY (Supplier_Order_ID) REFERENCES Supplier_Order(Supplier_Order_ID)
)

CREATE TABLE Supplier_Order_Detail_Raw_Material
(
    Quantity  						integer NOT NULL,
    Price     						money NOT NULL,
    Quantity_Received        		integer NOT NULL,
    Dimensions               		varchar(40) NOT NULL,
    Raw_Material_ID          		integer NOT NULL,
    Supplier_Order_ID        		integer NOT NULL,
    CONSTRAINT Supplier_Order_Detail_Raw_Material_PK PRIMARY KEY NONCLUSTERED (Raw_Material_ID,Supplier_Order_ID),
     FOREIGN KEY (Raw_Material_ID) REFERENCES Raw_Material(Raw_Material_ID),
     FOREIGN KEY (Supplier_Order_ID) REFERENCES Supplier_Order(Supplier_Order_ID)
)

CREATE TABLE Recipe
(
    Recipe_ID                		integer NOT NULL,
    Recipe_Type              		varchar(15) NOT NULL,
    Quantity_Required        		integer NOT NULL,
    Stage_in_Manufacturing   		integer NOT NULL,
    Part_Type_ID             		integer,
	Item_ID          				integer,
	Item_Name						varchar(50),
	Dimension						varchar(40),
    CONSTRAINT Part_Recipe_PK PRIMARY KEY NONCLUSTERED (Recipe_ID),
	 FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Unique_Raw_Material
(
    Unique_Raw_Material_ID   		integer NOT NULL,
    Raw_Material_ID          		integer NOT NULL,
    Dimension 						varchar(40) NOT NULL,
    Quality 						varchar(2) NOT NULL,
    Date_Added 						datetime NOT NULL,
    Date_Used 						datetime,
    Cost_Price						money NOT NULL,
    Supplier_Order_ID        		integer,
    CONSTRAINT Unique_Raw_Material_PK PRIMARY KEY NONCLUSTERED (Unique_Raw_Material_ID),
     FOREIGN KEY (Raw_Material_ID) REFERENCES Raw_Material(Raw_Material_ID),
     FOREIGN KEY (Supplier_Order_ID) REFERENCES Supplier_Order(Supplier_Order_ID)
)

CREATE TABLE Component_Supplier
(
    is_preferred             		bit NOT NULL,
    unit_price               		money NOT NULL,
    Component_ID             		integer NOT NULL,
    Supplier_ID              		integer NOT NULL,
    CONSTRAINT Component_Supplier_PK PRIMARY KEY NONCLUSTERED (Component_ID,Supplier_ID),
     FOREIGN KEY (Component_ID) REFERENCES Component(Component_ID),
     FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
)

CREATE TABLE Supplier_Return
(
    Supplier_Return_ID       		integer NOT NULL,
    Supplier_Order_ID        		integer NOT NULL,
    Date_of_Return           		datetime NOT NULL,
    Invoice_Number           		varchar(20) NOT NULL,
    Delivery_Note_Number     		varchar(20) NOT NULL,
    Comment                  		varchar(255) NOT NULL,
	CONSTRAINT Supplier_Return_PK PRIMARY KEY NONCLUSTERED (Supplier_Return_ID),
     FOREIGN KEY (Supplier_Order_ID) REFERENCES Supplier_Order(Supplier_Order_ID)
)

CREATE TABLE Supplier_Return_Item
(
    Return_Item_ID           		integer NOT NULL,
    Supplier_Return_ID       		integer NOT NULL,
    Type_of_Inventory        		varchar(20) NOT NULL,
    Inventory_ID             		integer NOT NULL,
    Units_Returned           		integer NOT NULL,
	Item_Name						varchar(50),
    CONSTRAINT Supplier_Return_Item_PK PRIMARY KEY NONCLUSTERED (Return_Item_ID),
	 FOREIGN KEY (Supplier_Return_ID) REFERENCES Supplier_Return(Supplier_Return_ID)
)

CREATE TABLE Invoice
(
    Invoice_ID               		integer NOT NULL,
    Invoice_Date             		datetime NOT NULL,
    Invoice_Status_ID        		integer NOT NULL,
    Delivery_Note_ID         		integer NOT NULL,
	amount_noVat					money NOT NULL,
	amount_Vat						money NOT NULL,
    CONSTRAINT Invoice_PK PRIMARY KEY NONCLUSTERED (Invoice_ID),
     FOREIGN KEY (Invoice_Status_ID) REFERENCES Invoice_Status(Invoice_Status_ID),
     FOREIGN KEY (Delivery_Note_ID) REFERENCES Delivery_Note(Delivery_Note_ID)
)

CREATE TABLE Delivery_Note_Details
(
    Quantity_Delivered       		integer NOT NULL,
    Client_Order_Detail_ID   		integer NOT NULL,
    Delivery_Note_ID         		integer NOT NULL,
    CONSTRAINT Delivery_Note_Details_PK PRIMARY KEY NONCLUSTERED (Client_Order_Detail_ID,Delivery_Note_ID),
     FOREIGN KEY (Client_Order_Detail_ID) REFERENCES Client_Order_Detail(Client_Order_Detail_ID),
     FOREIGN KEY (Delivery_Note_ID) REFERENCES Delivery_Note(Delivery_Note_ID)
)

CREATE TABLE Client_Quote_Detail
(
    Quantity                 		integer NOT NULL,
    Part_Price               		money NOT NULL,
    Client_Discount_Rate     		float NOT NULL,
    Settlement_Discount_Rate 		float NOT NULL,
    Client_Quote_ID          		integer NOT NULL,
    Part_Type_ID             		integer NOT NULL,
    CONSTRAINT Client_Quote_Details_PK PRIMARY KEY NONCLUSTERED (Client_Quote_ID,Part_Type_ID),
     FOREIGN KEY (Client_Quote_ID) REFERENCES Client_Quote(Client_Quote_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Invoice_Payment
(
    Payment_ID               		integer NOT NULL,
    Invoice_ID               		integer NOT NULL,
    Payment_Date             		date NOT NULL,
    Amount_Paid              		money NOT NULL,
    CONSTRAINT Invoice_Payment_PK PRIMARY KEY NONCLUSTERED (Payment_ID),
     FOREIGN KEY (Invoice_ID) REFERENCES Invoice(Invoice_ID)
)

CREATE TABLE Client_Credit_Order
(
    Client_Credit_Order_ID   		integer NOT NULL,
    Quantity_Returned        		integer NOT NULL,
    Date_Returned            		datetime NOT NULL,
    Client_Order_Detail_ID   		integer NOT NULL,
	Return_Comment           		varchar(500) NOT NULL,
    CONSTRAINT Client_Credit_Order_PK PRIMARY KEY NONCLUSTERED (Client_Credit_Order_ID),
     FOREIGN KEY (Client_Order_Detail_ID) REFERENCES Client_Order_Detail(Client_Order_Detail_ID)
)

CREATE TABLE Part
(
	Part_ID							integer NOT NULL,
    Part_Serial              		varchar(25),
    Part_Status_ID           		integer NOT NULL,
    Date_Added   			 		datetime NOT NULL,
    Cost_Price          	 		money NOT NULL,
    Part_Stage        		 		integer NOT NULL,
    Parent_ID                		integer NOT NULL,
    Part_Type_ID             		integer NOT NULL,
    CONSTRAINT Part_PK PRIMARY KEY NONCLUSTERED (Part_ID),
     FOREIGN KEY (Part_Status_ID) REFERENCES Part_Status(Part_Status_ID),
     FOREIGN KEY (Part_Type_ID) REFERENCES Part_Type(Part_Type_ID)
)

CREATE TABLE Production_Task
(
    Production_Task_ID       		integer NOT NULL,
    Production_Task_Type     		varchar(25) NOT NULL,
    Resource_ID              		integer NOT NULL,
    Part_Stage               		integer NOT NULL,
	Part_ID                  		integer NOT NULL,
	Job_Card_ID              		integer NOT NULL,
    Production_Schedule_ID   		integer NOT NULL,
    Employee_ID              		int NOT NULL,
	start_time               		time NOT NULL,
    end_time                 		time NOT NULL,
    duration                 		int NOT NULL,
	complete						bit NOT NULL,
    CONSTRAINT Product_Task_PK PRIMARY KEY NONCLUSTERED (Production_Task_ID),
     FOREIGN KEY (Part_ID) REFERENCES Part(Part_ID),
     FOREIGN KEY (Job_Card_ID) REFERENCES Job_Card(Job_Card_ID),
     FOREIGN KEY (Production_Schedule_ID) REFERENCES Production_Schedule(Production_Schedule_ID),
     FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
)

CREATE TABLE Job_Card_Detail_Part
(
    Part_ID                  		integer NOT NULL,
    Job_Card_Details_ID      		integer NOT NULL,
    CONSTRAINT Job_Card_Detail_Part_PK PRIMARY KEY NONCLUSTERED (Part_ID,Job_Card_Details_ID),
     FOREIGN KEY (Part_ID) REFERENCES Part(Part_ID),
     FOREIGN KEY (Job_Card_Details_ID) REFERENCES Job_Card_Detail(Job_Card_Details_ID)
)

CREATE TABLE Part_Supplier_Order
(
    Part_ID                  		integer NOT NULL,
    Supplier_Order_ID        		integer NOT NULL,
    CONSTRAINT Unique_Part_Supplier_Order_PK PRIMARY KEY NONCLUSTERED (Part_ID,Supplier_Order_ID),
     FOREIGN KEY (Part_ID) REFERENCES Part(Part_ID),
     FOREIGN KEY (Supplier_Order_ID) REFERENCES Supplier_Order(Supplier_Order_ID)
)

CREATE TABLE Customer_Credit
(
    Customer_Credit_ID              integer NOT NULL,
    Date        					DateTime NOT NULL,
	Return_Comment					varchar(255) NOT NULL,
    CONSTRAINT Customer_Credit_PK PRIMARY KEY NONCLUSTERED (Customer_Credit_ID)
)

CREATE TABLE Customer_Credit_Detail
(
    Customer_Credit_ID             	integer NOT NULL,
    Part_ID				        	integer NOT NULL,
	Client_Order_Detail_ID			integer NOT NULL,
	Status							varchar(20),
    CONSTRAINT Customer_Credit_Detail_PK PRIMARY KEY NONCLUSTERED (Customer_Credit_ID,Part_ID),
     FOREIGN KEY (Part_ID) REFERENCES Part(Part_ID),
     FOREIGN KEY (Customer_Credit_ID) REFERENCES Customer_Credit(Customer_Credit_ID)
)

Create TABLE Access
(
	Access_ID 						int NOT NULL,
	Name 							varchar(80) NOT NULL,
	href 							varchar(40) NOT NULL,
	CONSTRAINT Access_PK PRIMARY KEY NONCLUSTERED (Access_ID)
)

Create TABLE Access_Employee_Type
(
	Employee_Type_ID 				int NOT NULL,
	Access_ID 						int NOT NULL,
	Acess 							bit NOT NULL,
	CONSTRAINT Access_Employee_Type_PK PRIMARY KEY NONCLUSTERED (Employee_Type_ID,Access_ID),
     FOREIGN KEY (Access_ID) REFERENCES Access(Access_ID),
     FOREIGN KEY (Employee_Type_ID) REFERENCES Employee_Type(Employee_Type_ID)
)

CREATE TABLE Employee_Photo
(
	photo_ID						int NOT NULL,
	Employee_ID						int NOT NULL,
	Name							varchar(100) NOT NULL,
	File_Type						varchar(6) NOT NULL,
	Name_on_Server					varchar(255) NOT NULL,
	CONSTRAINT Employee_Photo_PK PRIMARY KEY NONCLUSTERED (photo_ID),
     FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
)

GO

INSERT INTO Audit_Type (Audit_Type_ID, Name, Description) VALUES (1, 'Insert', 'A new value has been inserted.')
INSERT INTO Audit_Type (Audit_Type_ID, Name, Description) VALUES (2, 'Read', 'Record has been selected.')
INSERT INTO Audit_Type (Audit_Type_ID, Name, Description) VALUES (3, 'Update', 'Record has been updated.')
INSERT INTO Audit_Type (Audit_Type_ID, Name, Description) VALUES (4, 'Delete', 'Record has been deleted.')

INSERT INTO Province (Province_ID, Province) VALUES (1, 'Eastern Cape')
INSERT INTO Province (Province_ID, Province) VALUES (2, 'Free State')
INSERT INTO Province (Province_ID, Province) VALUES (3, 'Gauteng')
INSERT INTO Province (Province_ID, Province) VALUES (4, 'KwaZulu-Natal')
INSERT INTO Province (Province_ID, Province) VALUES (5, 'Limpopo')
INSERT INTO Province (Province_ID, Province) VALUES (6, 'Mpumulanga')
INSERT INTO Province (Province_ID, Province) VALUES (7, 'North West')
INSERT INTO Province (Province_ID, Province) VALUES (8, 'Northern Cape')
INSERT INTO Province (Province_ID, Province) VALUES (9, 'Western Cape')

INSERT INTO Gender (Gender_ID, Gender_Name) VALUES ('M', 'Male')
INSERT INTO Gender (Gender_ID, Gender_Name) VALUES ('F', 'Female')
INSERT INTO Gender (Gender_ID, Gender_Name) VALUES ('O', 'Other')

INSERT INTO Part_Status (Part_Status_ID, Name, [Description]) VALUES (1, 'Raw', 'The part has not yet been produced')
INSERT INTO Part_Status (Part_Status_ID, Name, [Description]) VALUES (2, 'In-Production', 'The part is currently being produced')
INSERT INTO Part_Status (Part_Status_ID, Name, [Description]) VALUES (3, 'In-Stock', 'The part has been constructed and is ready to be used or sold')
INSERT INTO Part_Status (Part_Status_ID, Name, [Description]) VALUES (4, 'Returned', 'The part has been returned to the supplier who supplied it')
INSERT INTO Part_Status (Part_Status_ID, Name, [Description]) VALUES (5, 'Cancelled', 'The production for the part has been cancelled')
INSERT INTO Part_Status (Part_Status_ID, Name, [Description]) VALUES (6, 'Sub-Contractor', 'The part has been sent to a sub-contractor')
INSERT INTO Part_Status (Part_Status_ID, Name, [Description]) VALUES (7, 'Used', 'The part has been used to construct another part')
INSERT INTO Part_Status (Part_Status_ID, Name, [Description]) VALUES (8, 'Scrapped', 'The part can no longer be used and needs to be scrapped')
INSERT INTO Part_Status (Part_Status_ID, Name, [Description]) VALUES (9, 'Delivered', 'The part has been sold to a third party')

INSERT INTO VAT ([Date], VAT_Rate) VALUES (2016-01-01, 0.14)

INSERT INTO Machine_Status (Machine_Status_ID, Name, Description) VALUES (1, 'Active', 'The Machine is currently in use.')
INSERT INTO Machine_Status (Machine_Status_ID, Name, Description) VALUES (2, 'Broken', 'The Machine is currently broken.')
INSERT INTO Machine_Status (Machine_Status_ID, Name, Description) VALUES (3, 'Needs Maintenance', 'The Machine currently needs maintenance.')
INSERT INTO Machine_Status (Machine_Status_ID, Name, Description) VALUES (4, 'In-Active', 'The Machine is currently not in use.')

INSERT INTO Supplier_Order_Status (Supplier_Order_Status_ID, Name, Description) VALUES (1, 'Placed', '')
INSERT INTO Supplier_Order_Status (Supplier_Order_Status_ID, Name, Description) VALUES (2, 'Partially - Received', '')
INSERT INTO Supplier_Order_Status (Supplier_Order_Status_ID, Name, Description) VALUES (3, 'Partially - Paid and Received', '')
INSERT INTO Supplier_Order_Status (Supplier_Order_Status_ID, Name, Description) VALUES (4, 'Paid and Partially-Received', '')
INSERT INTO Supplier_Order_Status (Supplier_Order_Status_ID, Name, Description) VALUES (5, 'Fully Received but not Paid', '')
INSERT INTO Supplier_Order_Status (Supplier_Order_Status_ID, Name, Description) VALUES (6, 'Fully Received and Paid', '')
INSERT INTO Supplier_Order_Status (Supplier_Order_Status_ID, Name, Description) VALUES (7, 'Cancelled', '')
INSERT INTO Supplier_Order_Status (Supplier_Order_Status_ID, Name, Description) VALUES (8, 'Returned', '')

INSERT INTO Delivery_Method (Delivery_Method_ID, Name, Description) VALUES (1, 'Partial Delivery', '')
INSERT INTO Delivery_Method (Delivery_Method_ID, Name, Description) VALUES (2, 'Full Delivery', '')

INSERT INTO Client_Order_Status (Client_Order_Status_ID, Name, Description) VALUES (1, 'Ordered', '')
INSERT INTO Client_Order_Status (Client_Order_Status_ID, Name, Description) VALUES (2, 'Delivered', '')
INSERT INTO Client_Order_Status (Client_Order_Status_ID, Name, Description) VALUES (3, 'Returned', '')
INSERT INTO Client_Order_Status (Client_Order_Status_ID, Name, Description) VALUES (4, 'Cancelled', '')

INSERT INTO Job_Card_Priority (Job_Card_Priority_ID, Name, Description) VALUES (1, 'Customer', '')
INSERT INTO Job_Card_Priority (Job_Card_Priority_ID, Name, Description) VALUES (2, 'Manufacturing', '')

INSERT INTO Job_Card_Status (Job_Card_Status_ID, Name, Description) VALUES (1, 'Started', '')
INSERT INTO Job_Card_Status (Job_Card_Status_ID, Name, Description) VALUES (2, 'In-Production', '')
INSERT INTO Job_Card_Status (Job_Card_Status_ID, Name, Description) VALUES (3, 'Completed', '')
INSERT INTO Job_Card_Status (Job_Card_Status_ID, Name, Description) VALUES (4, 'Cancelled', '')
INSERT INTO Job_Card_Status (Job_Card_Status_ID, Name, Description) VALUES (5, 'Scrapped', '')

INSERT INTO Client_Order_Type (Client_Order_Type_ID, Type, Description) VALUES (1, 'Cash Sale', '')
INSERT INTO Client_Order_Type (Client_Order_Type_ID, Type, Description) VALUES (2, 'Contracted Sale', '')

INSERT INTO Invoice_Status (Invoice_Status_ID, Name, Description) VALUES (1, 'Unpaid', '')
INSERT INTO Invoice_Status (Invoice_Status_ID, Name, Description) VALUES (2, 'Partially Paid', '')
INSERT INTO Invoice_Status (Invoice_Status_ID, Name, Description) VALUES (3, 'Paid', '')

INSERT INTO Access VALUES (1, 'Add Employee','AddEmployee')
INSERT INTO Access VALUES (2, 'Maintain Employee','MaintainEmployee')
INSERT INTO Access VALUES (3, 'Add Employee Category','AddEmployeeCategory')
INSERT INTO Access VALUES (4, 'Maintain Employee Category','MaintainEmployeeCategory')
INSERT INTO Access VALUES (5, 'Search Employees','SearchEmployee')

INSERT INTO Access VALUES (6, 'Add Customer','AddCustomer')
INSERT INTO Access VALUES (7, 'Maintain Customer','MaintainCustomer')
INSERT INTO Access VALUES (8, 'Search Customers','SearchCustomer')

INSERT INTO Access VALUES (9, 'Add Raw Material','AddRawMaterial')
INSERT INTO Access VALUES (10, 'Maintain Raw Material','MaintainRawMaterial')
INSERT INTO Access VALUES (11, 'Add Part Type','AddPartType')
INSERT INTO Access VALUES (12, 'Maintain Part Type','MaintainPartType')
INSERT INTO Access VALUES (13, 'Add Part','AddPart')
INSERT INTO Access VALUES (14, 'Maintain Part','MaintainPart')
INSERT INTO Access VALUES (15, 'Search Inventory','SearchInventory')
INSERT INTO Access VALUES (16, 'Add Part Status','AddPartStatus')
INSERT INTO Access VALUES (17, 'Maintain Part Status','MaintainPartStatus')
INSERT INTO Access VALUES (18, 'Add Unique Raw Material','AddUniqueRawMaterial')
INSERT INTO Access VALUES (19, 'Maintain Unique Raw Material','MaintainUniqueRawMaterial')
INSERT INTO Access VALUES (20, 'Add Component','AddComponent')
INSERT INTO Access VALUES (21, 'Maintain a Component','MaintainComponent')
INSERT INTO Access VALUES (22, 'Update Part Statuses','UpdatePartStatuses')

INSERT INTO Access VALUES (23, 'Add Job Card','GenerateJobCard')
INSERT INTO Access VALUES (24, 'Maintain Job Card','MaintainJobCard')
INSERT INTO Access VALUES (25, 'Add Manual Labour','AddManualLabourType')
INSERT INTO Access VALUES (26, 'Maintain Manual Labour','MaintainManualLabourType')
INSERT INTO Access VALUES (27, 'Generate Production Schedule','GenerateProductionSchedule')
INSERT INTO Access VALUES (28, 'Maintain Production Schedule','MaintainProductionSchedule')
INSERT INTO Access VALUES (29, 'View the Production Schedule','ViewProductionSchedule')

INSERT INTO Access VALUES (30, 'Add Supplier','AddSupplier')
INSERT INTO Access VALUES (31, 'Maintain Supplier','MaintainSupplier')
INSERT INTO Access VALUES (32, 'Add Supplier Quote','AddSupplierQuote')
INSERT INTO Access VALUES (33, 'Place Purchase Order','PlaceSupplierOrder')
INSERT INTO Access VALUES (34, 'Maintain Purchase Order','MaintainSupplierOrder')
INSERT INTO Access VALUES (35, 'Search Purchase Orders/Quotes','SearchSupplierOrder')
INSERT INTO Access VALUES (36, 'Receive Supplier Purchase Order','ReceivePurchaseOrder')
INSERT INTO Access VALUES (37, 'View Purchase Back Orders','ViewOustandingPurchaseOrders')
INSERT INTO Access VALUES (38, 'Search Suppliers','SearchSupplier')
INSERT INTO Access VALUES (39, 'Generate a Goods Returned Note','GenerateGoodsReturnedNote')

INSERT INTO Access VALUES (40, 'Generate Customer Quote','GenerateCustomerQuote')
INSERT INTO Access VALUES (41, 'Place Customer Order','PlaceCustomerOrder')
INSERT INTO Access VALUES (42, 'Generate Price List','GeneratePriceList')
INSERT INTO Access VALUES (43, 'Maintain Customer Order','MaintainCustomerOrder')
INSERT INTO Access VALUES (44, 'Generate Delivery Note','GenerateDeliveryNote')
INSERT INTO Access VALUES (45, 'Generate Invoice','GenerateInvoice')
INSERT INTO Access VALUES (46, 'Finalise Customer Order','ViewOutstandingCustomerOrders')
INSERT INTO Access VALUES (47, 'View Back Orders','FinaliseCustomerOrder')
INSERT INTO Access VALUES (48, 'Search Customer Orders/Quotes','SearchCustomerOrders')
INSERT INTO Access VALUES (49, 'Maintain VAT','MaintainVAT')
INSERT INTO Access VALUES (50, 'Generate Credit Note','GenerateCreditNote')

INSERT INTO Access VALUES (51, 'Add Sub-Contractor','AddSubContractor')
INSERT INTO Access VALUES (52, 'Maintain Sub-Contractor','MaintainSubContractor')
INSERT INTO Access VALUES (53, 'Search Sub-Contractors','SearchSubContractor')

INSERT INTO Access VALUES (54, 'Add Machine','AddMachine')
INSERT INTO Access VALUES (55, 'Maintain Machine','MaintainMachine')
INSERT INTO Access VALUES (56, 'Add Unique Machine','AddUniqueMachine')
INSERT INTO Access VALUES (57, 'Maintain Unique Machine','MaintainUniqueMachine')
INSERT INTO Access VALUES (58, 'Maintain Unique Machine Statuses','MaintainUniqueMachineStatus')
INSERT INTO Access VALUES (59, 'Search Machines','SearchMachine')

INSERT INTO Access VALUES (60, 'Generate Reports','http://localhost/Reports')

INSERT [dbo].[Supplier] ([Supplier_ID], [Name], [Address], [City], [Zip], [Bank_Account_Number], [Bank_Branch], [Bank_Name], [Email], [Contact_Number], [Status], [Province_ID], [Bank_Reference], [Contact_Name], [Foreign_Bank]) VALUES (1, N'Quick Supplies', N'645 Glendower', N'Pretoria', N'0076', N'6896743575', N'63200', N'ABSA', N'jimmy@quicksupp.co.za', N'0844004167', 1, 3, N'Quick Supplies', N'Jimmy Hendrix', 0)
INSERT [dbo].[Supplier] ([Supplier_ID], [Name], [Address], [City], [Zip], [Bank_Account_Number], [Bank_Branch], [Bank_Name], [Email], [Contact_Number], [Status], [Province_ID], [Bank_Reference], [Contact_Name], [Foreign_Bank]) VALUES (2, N'Inv. Supplies', N'99 Bedford Street', N'Johannesburg', N'2027', N'7896663575', N'198765', N'Nedbank', N'Mj@gmail.com', N'0845004167', 1, 3, N'Inv.Supplies', N'Michael Jackson', 0)
INSERT [dbo].[Component] ([Component_ID], [Quantity], [Unit_Price], [Description], [Dimension], [Name], [Min_Stock]) VALUES (1, 200, 10.0000, N'A movable bar or rod that when slid into a socket fastens a door, gate, etc', N'6x6x6', N'Bolts', 10)
INSERT [dbo].[Component] ([Component_ID], [Quantity], [Unit_Price], [Description], [Dimension], [Name], [Min_Stock]) VALUES (2, 70, 20.0000, N' A fitting, consisting of a short piece of pipe, usually provided with a male pipe thread at each end, for connecting two other fittings', N'12x6x4', N'Barrel Nipple', 10)
INSERT [dbo].[Component] ([Component_ID], [Quantity], [Unit_Price], [Description], [Dimension], [Name], [Min_Stock]) VALUES (3, 400, 7.0000, N'The part which is held against a groove or grooves on the valve stem and in turn holds the valve spring in a state of compression', N'2x2x2', N'Spring Retainer', 10)
INSERT [dbo].[Component] ([Component_ID], [Quantity], [Unit_Price], [Description], [Dimension], [Name], [Min_Stock]) VALUES (4, 350, 20.0000, N'Flat-sided nut for cylinder fixing', N'2x2x2', N'House Nut', 10)
INSERT [dbo].[Part_Type] ([Part_Type_ID], [Abbreviation], [Name], [Description], [Selling_Price], [Dimension], [Minimum_Level], [Maximum_Level], [Max_Discount_Rate], [Manufactured], [Average_Completion_Time], [Number_Of_Stages]) VALUES (1, N'POM', N'Pompie', N'The ORIGINAL POMPIE Air driven Submersible Pump with over 30 years of service in the Mining Industry', 20000.0000, N'350 x 260 x 550', 20, 200, 10, 1, 880, 4)
INSERT [dbo].[Raw_Material] ([Name], [Description], [Minimum_Stock_Instances], [Raw_Material_ID]) VALUES (N'Copper', N'Reddish-brown, stretchable and metallic element, or something that is reddish-brown in color', 0, 1)
INSERT [dbo].[Raw_Material] ([Name], [Description], [Minimum_Stock_Instances], [Raw_Material_ID]) VALUES (N'Iron Ore', N'A heavy ductile magnetic metallic element; is silver-white in pure form but readily rusts', 0, 2)
INSERT [dbo].[Raw_Material] ([Name], [Description], [Minimum_Stock_Instances], [Raw_Material_ID]) VALUES (N'Metal', N'Any of a category of electropositive elements that usually have a shiny surface, are generally good conductors of heat and electricity, and can be melted or fused, hammered into thin sheets, or drawn into wires', 0, 3)
INSERT [dbo].[Component_Supplier] ([is_preferred], [unit_price], [Component_ID], [Supplier_ID]) VALUES (1, 6.0000, 1, 1)
INSERT [dbo].[Component_Supplier] ([is_preferred], [unit_price], [Component_ID], [Supplier_ID]) VALUES (0, 10.0000, 4, 2)
INSERT [dbo].[Manual_Labour_Type] ([Manual_Labour_Type_ID], [Name], [Description], [Duration], [Sub_Contractor]) VALUES (1, N'Welding', N'Lays out, positions, and secures parts and assemblies according to specifications, using straightedge, combination square, calipers, and ruler', 45, 0)
INSERT [dbo].[Manual_Labour_Type] ([Manual_Labour_Type_ID], [Name], [Description], [Duration], [Sub_Contractor]) VALUES (2, N'Assembly', N'Fabricates parts and joins them together to construct pumps', 180, 0)
INSERT [dbo].[Manual_Labour_Type] ([Manual_Labour_Type_ID], [Name], [Description], [Duration], [Sub_Contractor]) VALUES (3, N'Painter', N'Apply paint to part already made ', 200, 1)
INSERT [dbo].[Machine] ([Machine_ID], [Name], [Manufacturer], [Model], [Price_Per_Hour], [Run_Time]) VALUES (1, N'Okuma CRC', N'Okuma', N'OSP-P300', 6000.0000, 300)
INSERT [dbo].[Machine] ([Machine_ID], [Name], [Manufacturer], [Model], [Price_Per_Hour], [Run_Time]) VALUES (2, N'Genos Lathes', N'Okuma', N'L250', 1500.0000, 180)
INSERT [dbo].[Machine] ([Machine_ID], [Name], [Manufacturer], [Model], [Price_Per_Hour], [Run_Time]) VALUES (3, N'GI Grinder', N'Okuma', N'GI-10NII', 700.0000, 60)
INSERT [dbo].[Machine] ([Machine_ID], [Name], [Manufacturer], [Model], [Price_Per_Hour], [Run_Time]) VALUES (4, N'Mitsubishi Laser Cutting', N'Mitsubishi', N'3015LVP(PLUSII)', 400.0000, 30)
INSERT [dbo].[Machine] ([Machine_ID], [Name], [Manufacturer], [Model], [Price_Per_Hour], [Run_Time]) VALUES (5, N'DMC Vertical Machining Center', N'Heartland', N'DM 43VCD', 4000.0000, 500)
INSERT [dbo].[Unique_Machine] ([Unique_Machine_ID], [Unique_Machine_Serial], [Machine_Status_ID], [Machine_ID]) VALUES (1, N'N9TT-9G0A-B7FQ-RANC', 1, 1)
INSERT [dbo].[Unique_Machine] ([Unique_Machine_ID], [Unique_Machine_Serial], [Machine_Status_ID], [Machine_ID]) VALUES (2, N'SXFP-CHYK-ONI6-S89U', 3, 5)
INSERT [dbo].[Unique_Machine] ([Unique_Machine_ID], [Unique_Machine_Serial], [Machine_Status_ID], [Machine_ID]) VALUES (3, N'SXFP-H93J-ONI6-S89U', 2, 5)
INSERT [dbo].[Unique_Machine] ([Unique_Machine_ID], [Unique_Machine_Serial], [Machine_Status_ID], [Machine_ID]) VALUES (4, N'XNAM-9G0A-B7FQ-RANC', 1, 1)
INSERT [dbo].[Unique_Machine] ([Unique_Machine_ID], [Unique_Machine_Serial], [Machine_Status_ID], [Machine_ID]) VALUES (5, N'DDDD-CHYK-ONI6-S89U', 4, 2)
INSERT [dbo].[Unique_Machine] ([Unique_Machine_ID], [Unique_Machine_Serial], [Machine_Status_ID], [Machine_ID]) VALUES (6, N'7AR5-H93J-ONI6-S89U', 2, 4)
INSERT [dbo].[Employee_Type] ([Employee_Type_ID], [Name], [Description]) VALUES (1, N'Admin', N'Full access to system')
INSERT [dbo].[Employee_Type] ([Employee_Type_ID], [Name], [Description]) VALUES (2, N'General Manager', N'Responsible for managing a single unit, different sectors, or multiple units of a company or organization. Hires and trains employees, prepares reports, and sets budgets')
INSERT [dbo].[Employee_Type] ([Employee_Type_ID], [Name], [Description]) VALUES (3, N'Floor Manager', N'Provides materials, equipment, and supplies by directing receiving, warehousing, and distribution services; supervising staff')
INSERT [dbo].[Employee_Type] ([Employee_Type_ID], [Name], [Description]) VALUES (4, N'Financial Advisor', N'Financial managers are responsible for providing financial advice and support to clients and colleagues to enable them to make sound business decisions')
INSERT [dbo].[Employee_Type] ([Employee_Type_ID], [Name], [Description]) VALUES (5, N'Accountant', N'Provides financial information to management by researching and analyzing accounting data; preparing reports')
INSERT [dbo].[Employee_Type] ([Employee_Type_ID], [Name], [Description]) VALUES (6, N'Office Administrator', N'A secretary or administrator provides both clerical and administrative support to professionals, either as part of a team or individually. The role plays a vital part in the administration and smooth-running of businesses throughout industry')
INSERT [dbo].[Employee_Type] ([Employee_Type_ID], [Name], [Description]) VALUES (7, N'Factory Worker', N'The basic work of a factory worker is to operate machines in a safe manner and make sure that it meets all standards enforced by the company')
INSERT [dbo].[Employee_Type] ([Employee_Type_ID], [Name], [Description]) VALUES (8, N'Unemployed', N'Are no longer part of Walter Meano Engineering')
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (1, N'Matthew', N'Swanepoel', N'9504255100085', N'0737894412', N'9d6cce397f3026c4e70c879a9844921f20497fd83394f779a88db094fc557285', N'4k1EyLWh', N'u14002362', N'u14002362@tuks.co.za', 1, N'M', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (2, N'John', N'Snow', N'6004255199985', N'0837855412', N'caa0c7502e2e8bbb0774b99cf964e744bc0eaebb840abdcfa9bc518dd98492a1', N'YhZ4O+gE', N'Stark', N'johnsnow@gmail.com', 2, N'M', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (3, N'Tanya', N'Börner', N'9504255100088', N'0722221765', N'559b19fb8889fa6f57d97aea45cf40a8674ee81415f32f6eb4a084600d52e28f', N'LbKBb+u1', N'u14343305', N'u14343305@tuks.co.za', 1, N'F', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (4, N'Christopher', N'Park', N'9506255199985', N'0822221765', N'f2c66f89df5d193abcc2817f746df74d9de0a00cb96358d07426ceb64a360e4c', N'e6oAu27l', N'Chris', N'chrisparker@gmail.com', 7, N'M', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (5, N'Armand', N'Kamffer', N'9504266100085', N'0796251306', N'8500f182eeef21bcf6d66f25958823ba40930931885db80917f29bd81de5a13f', N'gmT0JEb0', N'u14007496', N'u14007496@tuks.co.za', 1, N'M', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (6, N'Samantha', N'Cardone', N'9003255111185', N'0847894412', N'b0a61e4fa09f7e6a1d903f4dc550c88fbb81537b5b63affbb696eb6f672f34ed', N'V6lS/bdq', N'Sam', N'Sam@gmail.com', 6, N'F', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (7, N'Revingstone', N'Mwalugha', N'9503255111185', N'0714968691', N'f68b7e8d6a31070edd5009df24f9d9cab8183c2311fd9348cf7a068724078463', N'sni9dg/N', N'u14341558', N'u14341558@tuks.co.za', 1, N'M', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (8, N'Natasha', N'Schoeman', N'9506255111185', N'0739512288', N'19d6aa048980e7ef30e2fb53d2b60129ba4eac0ab985e46e5326cc126aa5ca2f', N'1s7P+r+/', N'u14009562', N'u14009562@tuks.co.za', 1, N'F', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (9, N'Lisa', N'Gouws', N'9606255111185', N'0729512288', N'3cb5c11eac858f3649183f12c8b457f4fb7c9d03b65fedc41b1ba4e8998646e8', N'7OJvZjxp', N'Lisa', N'Lisagouws@yahoo.co.za', 5, N'F', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (10, N'Nicholas', N'Snyman', N'9306255111185', N'0849512288', N'0250565a84ccc871944ca8e8248c44054f7fc5b392e54c2e533b866f344a4ab7', N'ZDdEYD5H', N'Nick', N'Nick@yahoo.co.za', 4, N'M', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (11, N'Gert', N'Coetzee', N'8906255111185', N'0849662277', N'37b1c0dbfda7b0ff8bedcd36b11e78a649853ad5aca736e1fe3e18843870e806', N'15oJeWEM', N'Gert', N'Gert@mweb.co.za', 3, N'M', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (12, N'Hank', N'Smith', N'8006255111185', N'0845552277', N'fc549fcb493d2f6c6da2328caf34327de423b6193d19ad935a7dfc3c473a8e00', N'g/HI79aY', N'Hank', N'Hank@mweb.co.za', 7, N'M', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (13, N'Warren', N'James', N'8107255111185', N'0845552555', N'f0473cc7f63a4bd904c9a5ad48d51a1c89ac286055b0504665ebf795759b05e8', N'6UMV3Hmx', N'Warren', N'Warren@hotmail.co.za', 7, N'M', 1)
INSERT [dbo].[Employee] ([Employee_ID], [Name], [Surname], [ID_Number], [Contact_Number], [Password], [Salt], [Username], [Email], [Employee_Type_ID], [Gender_ID], [Employee_Status]) VALUES (14, N'Francis', N'Venter', N'6707255111185', N'0829992555', N'fed4a34066ecd33550dcc9bdcfdc6ffcc0e87d26ebf3879e22b0036733c80560', N'hWnC/cA1', N'Francis', N'Francis@hotmail.co.za', 8, N'M', 1)
INSERT [dbo].[Machine_Part] ([Stage_In_Manufacturing], [Machine_ID], [Part_Type_ID]) VALUES (1, 1, 1)
INSERT [dbo].[Machine_Employee] ([Employee_ID], [Machine_ID]) VALUES (4, 1)
INSERT [dbo].[Machine_Employee] ([Employee_ID], [Machine_ID]) VALUES (12, 1)
INSERT [dbo].[Machine_Employee] ([Employee_ID], [Machine_ID]) VALUES (12, 2)
INSERT [dbo].[Machine_Employee] ([Employee_ID], [Machine_ID]) VALUES (12, 3)
INSERT [dbo].[Machine_Employee] ([Employee_ID], [Machine_ID]) VALUES (12, 4)
INSERT [dbo].[Machine_Employee] ([Employee_ID], [Machine_ID]) VALUES (12, 5)
INSERT [dbo].[Manual_Labour_Type_Part] ([Stage_In_Manufacturing], [Manual_Labour_Type_ID], [Part_Type_ID]) VALUES (2, 2, 1)
INSERT [dbo].[Manual_Labour_Employee] ([Manual_Labour_Type_ID], [Employee_ID]) VALUES (2, 4)
INSERT [dbo].[Manual_Labour_Employee] ([Manual_Labour_Type_ID], [Employee_ID]) VALUES (1, 13)
INSERT [dbo].[Manual_Labour_Employee] ([Manual_Labour_Type_ID], [Employee_ID]) VALUES (2, 13)
INSERT [dbo].[Manual_Labour_Employee] ([Manual_Labour_Type_ID], [Employee_ID]) VALUES (3, 13)
INSERT [dbo].[Sub_Contractor] ([Sub_Contractor_ID], [Name], [Address], [City], [Zip], [Status], [Manual_Labour_Type_ID], [Province_ID]) VALUES (1, N'Jacks Paint', N'247 President Street', N'Johannesburg', N'1627', 0, 3, 3)
INSERT [dbo].[Sub_Contractor] ([Sub_Contractor_ID], [Name], [Address], [City], [Zip], [Status], [Manual_Labour_Type_ID], [Province_ID]) VALUES (2, N'Thabo Factory Shop', N'260 President Street', N'Johannesburg', N'1627', 1, 3, 3)
INSERT [dbo].[Sub_Contractor] ([Sub_Contractor_ID], [Name], [Address], [City], [Zip], [Status], [Manual_Labour_Type_ID], [Province_ID]) VALUES (3, N'Dulux Paint', N'360 Sawdawn Street', N'Johannesburg', N'2196', 0, 3, 3)
INSERT [dbo].[Recipe] ([Recipe_ID], [Recipe_Type], [Quantity_Required], [Stage_in_Manufacturing], [Part_Type_ID], [Item_ID], [Item_Name]) VALUES (5, N'Raw Material', 0, 3, 1, 3, N'Metal')
INSERT [dbo].[Recipe] ([Recipe_ID], [Recipe_Type], [Quantity_Required], [Stage_in_Manufacturing], [Part_Type_ID], [Item_ID], [Item_Name]) VALUES (6, N'Raw Material', 0, 4, 1, 2, N'Iron ore')
INSERT [dbo].[Sub_Contractor_Contact_Detail] ([Contact_ID], [Sub_Contractor_ID], [Number], [Name], [Email]) VALUES (1, 1, N'0128835177', N'Jack Smith', N'jack.smith@jackspaint.co.za')
INSERT [dbo].[Sub_Contractor_Contact_Detail] ([Contact_ID], [Sub_Contractor_ID], [Number], [Name], [Email]) VALUES (2, 2, N'0129966177', N'Thabo Mbeki', N'ThaboMbeki@gmail.com')
INSERT [dbo].[Sub_Contractor_Contact_Detail] ([Contact_ID], [Sub_Contractor_ID], [Number], [Name], [Email]) VALUES (3, 3, N'0125566197', N'Jacob McKenzie', N'JZ@dulux.com')
	
INSERT INTO Employee (Employee_ID, Name, Surname, ID_Number, Contact_Number, Password, Salt, Username, Email, Employee_Type_ID, Gender_ID, Employee_Status)
	VALUES (15, 'Admin', 'Admin', '', '', '28dfb51f983bbc566538fd29172e6962ac120af67028ec94ad8a236f4dda4768', 'NWgWVA6p', 'admin', '', 1, 'O', 1)
	
INSERT INTO Access_Employee_Type VALUES (1, 1, 1)
INSERT INTO Access_Employee_Type VALUES (1, 2, 1)
INSERT INTO Access_Employee_Type VALUES (1, 3, 1)
INSERT INTO Access_Employee_Type VALUES (1, 4, 1)
INSERT INTO Access_Employee_Type VALUES (1, 5, 1)
INSERT INTO Access_Employee_Type VALUES (1, 6, 1)
INSERT INTO Access_Employee_Type VALUES (1, 7, 1)
INSERT INTO Access_Employee_Type VALUES (1, 8, 1)
INSERT INTO Access_Employee_Type VALUES (1, 9, 1)
INSERT INTO Access_Employee_Type VALUES (1, 10, 1)
INSERT INTO Access_Employee_Type VALUES (1, 11, 1)
INSERT INTO Access_Employee_Type VALUES (1, 12, 1)
INSERT INTO Access_Employee_Type VALUES (1, 13, 1)
INSERT INTO Access_Employee_Type VALUES (1, 14, 1)
INSERT INTO Access_Employee_Type VALUES (1, 15, 1)
INSERT INTO Access_Employee_Type VALUES (1, 16, 1)
INSERT INTO Access_Employee_Type VALUES (1, 17, 1)
INSERT INTO Access_Employee_Type VALUES (1, 18, 1)
INSERT INTO Access_Employee_Type VALUES (1, 19, 1)
INSERT INTO Access_Employee_Type VALUES (1, 20, 1)
INSERT INTO Access_Employee_Type VALUES (1, 21, 1)
INSERT INTO Access_Employee_Type VALUES (1, 22, 1)
INSERT INTO Access_Employee_Type VALUES (1, 23, 1)
INSERT INTO Access_Employee_Type VALUES (1, 24, 1)
INSERT INTO Access_Employee_Type VALUES (1, 25, 1)
INSERT INTO Access_Employee_Type VALUES (1, 26, 1)
INSERT INTO Access_Employee_Type VALUES (1, 27, 1)
INSERT INTO Access_Employee_Type VALUES (1, 28, 1)
INSERT INTO Access_Employee_Type VALUES (1, 29, 1)
INSERT INTO Access_Employee_Type VALUES (1, 30, 1)
INSERT INTO Access_Employee_Type VALUES (1, 31, 1)
INSERT INTO Access_Employee_Type VALUES (1, 32, 1)
INSERT INTO Access_Employee_Type VALUES (1, 33, 1)
INSERT INTO Access_Employee_Type VALUES (1, 34, 1)
INSERT INTO Access_Employee_Type VALUES (1, 35, 1)
INSERT INTO Access_Employee_Type VALUES (1, 36, 1)
INSERT INTO Access_Employee_Type VALUES (1, 37, 1)
INSERT INTO Access_Employee_Type VALUES (1, 38, 1)
INSERT INTO Access_Employee_Type VALUES (1, 39, 1)
INSERT INTO Access_Employee_Type VALUES (1, 40, 1)
INSERT INTO Access_Employee_Type VALUES (1, 41, 1)
INSERT INTO Access_Employee_Type VALUES (1, 42, 1)
INSERT INTO Access_Employee_Type VALUES (1, 43, 1)
INSERT INTO Access_Employee_Type VALUES (1, 44, 1)
INSERT INTO Access_Employee_Type VALUES (1, 45, 1)
INSERT INTO Access_Employee_Type VALUES (1, 46, 1)
INSERT INTO Access_Employee_Type VALUES (1, 47, 1)
INSERT INTO Access_Employee_Type VALUES (1, 48, 1)
INSERT INTO Access_Employee_Type VALUES (1, 49, 1)
INSERT INTO Access_Employee_Type VALUES (1, 50, 1)
INSERT INTO Access_Employee_Type VALUES (1, 51, 1)
INSERT INTO Access_Employee_Type VALUES (1, 52, 1)
INSERT INTO Access_Employee_Type VALUES (1, 53, 1)
INSERT INTO Access_Employee_Type VALUES (1, 54, 1)
INSERT INTO Access_Employee_Type VALUES (1, 55, 1)
INSERT INTO Access_Employee_Type VALUES (1, 56, 1)
INSERT INTO Access_Employee_Type VALUES (1, 57, 1)
INSERT INTO Access_Employee_Type VALUES (1, 58, 1)
INSERT INTO Access_Employee_Type VALUES (1, 59, 1)
INSERT INTO Access_Employee_Type VALUES (1, 60, 1)