from report_generator import ReportGenerator

config = {
    "TitleColour": "0b5394",
    "TitleFontColour": "000000",
    "HeaderColour": "FFFFFF",
    "HeaderFontColour": "000000",
    "OrgName": "RADIANT CASH MANAGEMENT SERVICES",
    "ClientName": "FOUR CODES",
    "Columns": {
        "dt.trans_id": {
            "aliasName": "TRANSACTION",
            "condition": [],
            "sumBy": "False"
        },
        "dt.pickup_code": {
            "aliasName": "PICKUP CODE",
            "condition": [
                # {
                #     "PICKUP CODE": "ALL",
                #     "defaultValue": "DEMO"
                # },
                # {
                #     "PICKUP CODE": "RSC231881",
                #     "defaultValue": "DEMO"
                # }
            ]
        },
        "dt.location": {
            "aliasName": "LOCATION",
            "condition": []
        },
        "dt.client_name": {
            "aliasName": "CLIENT NAME",
            "condition": [],
            "sumBy": "True"
        },
        "dt.cust_name": {
            "aliasName": "CUSTOMER NAME",
            "condition": [],
            "sumBy": "False"
        },
        "dt.pickup_name": {
            "aliasName": "PICKUP CODE",
            "condition": [],
            "sumBy": "False"
        },
        "dt.staff_id": {
            "aliasName": "STAFF ID",
            "condition": [
                {
                    "STAFF ID": "ALL",
                    "defaultValue": "DEMO"
                }
            ],
            "sumBy": "False"
        },
        "dc.multi_rec": {
            "aliasName": "MULTI RECEIPT",
            "condition": []
        },
        "dt.region": {
            "aliasName": "REGION",
            "condition": [
                {
                   "REGION": "Ahmedabad",
                   "defaultValue": "Gujarat" 
                }
            ]
        },
        "dc.pick_amount": {
            "aliasName": "PICKUP AMOUNT",
            "condition": [],
            "sumBy": "True"
        }
    },
    "includeCustomColumns": {
        "STATUS": {
            "enabled": "False",
            "condition": [
                {
                    "column": "PICKUP AMOUNT",
                    "type": "int",
                    "action": "=",
                    "matchValue": 0,
                    "ReplaceValue": "No attempt"
                },
                {
                    "column": "PICKUP AMOUNT",
                    "type": "int",
                    "action": ">",
                    "matchValue": 0,
                    "ReplaceValue": "Pickuped"
                }
            ],
            "position": "PICKUP AMOUNT"
        },
        "FORMULAS": {
            "enabled": "False",
            "condition": [
                {
                    "Actioncolumns": "PICKUP AMOUNT",
                    "operation": "PICKUP AMOUNT + PICKUP AMOUNT"
                }
            ],
            "position": "PICKUP AMOUNT",
            "sumBy": "True"
        },
        # "REPORT BY": {
        #     "enabled": "False",
        #     "condition": [],
        #     "position": "FORMULAS",
        #     "defaultValue": "GINO"
        # },
        # "APPROVED BY": {
        #     "enabled": "False",
        #     "condition": [],
        #     "position": "FORMULAS",
        #     "defaultValue": "NAVEEN"
        # },
        # "REQUESTED BY": {
        #     "enabled": "True",
        #     "condition": [],
        #     "position": "APPROVED BY",
        #     "defaultValue": "SURYA"
        # },
        # "CREATED BY": {
        #     "enabled": "True",
        #     "condition": [],
        #     "position": "REQUESTED BY",
        #     "defaultValue": "RAMESH"
        # }
    },
    "OrderBy": "CLIENT NAME",
    "Sheet": "Multi", 
    "TotalType": "individual",
    "SumLabelPostionColumnName": "REGION",
    "IncludeIndividualGrandTotal": "False",
    # "RowLimit": 
}

# Credentials 
password = "Write%409mF6yP"
username = "writeuser"
hostname = "demo.radianterp.in"
database = "rcmsdata"

report = ReportGenerator(config, password, username, hostname, database)
report.run_report()
