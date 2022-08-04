import { createStore } from 'vuex'

export default createStore({
  state() {
    return {
        show: false,
        title: "Fleeca Bank",
        characterName: "Kole Huey",
        cash: 0,
        accountTypes: [
          {
            id: 1,
            name: "Checking Account",
            icon: "credit_card",
            color: "purple",
            form: [
              { value: "", label: "Account Name", icon: "drive_file_rename_outline", name: "account_name"}
            ]
          },
          {
            id: 2,
            name: "Savings Account",
            icon: "savings",
            color: "teal",
            form: [
              { value: "", label: "Account Name", icon: "drive_file_rename_outline", name: "account_name"}
            ]
          },
        ],
        transactionTypes: [
          {
            id: 1,
            name: "Deposit",
            icon: "remove",
            color: "red",
            form: [
              { value: "", mask:"#############", prefix: "$", label: "Amount", icon: "attach_money", name: "amount" },
              { value: "", mask:"", prefix: "", label: "Note", icon: "note", name: "note" },
            ]
          },
          {
            id: 2,
            name: "Withdraw",
            icon: "add",
            color: "orange",
            form: [
              { value: "", mask:"#############", prefix: "$", label: "Amount", icon: "attach_money", name: "amount" },
              { value: "", mask:"", prefix: "", label: "Note", icon: "note", name: "note" },
            ]
          },
          {
            id: 3,
            name: "Transfer",
            icon: "arrow_forward",
            color: "blue",
            form: [
              { value: "", mask:"########", prefix: "", label: "Account Number", icon: "wallet", name: "account_id" },
              { value: "", mask:"#############", prefix: "$", label: "Amount", icon: "attach_money", name: "amount" },
              { value: "", mask:"", prefix: "", label: "Note", icon: "note", name: "note" },
            ]
          },
        ],
        data: {
          accounts: [
            {
              id: 1,
              name: "San Andreas State Police",
              type: "Business Account",
              accountnumber: 561341817,
              balance: 3000000,
              transactions: [
                {
                  id: 1,
                  type: "Withdrawl",
                  amount: "34520",
                  note: "Funds for a new cvpi.",
                  date: "2022-07-13 20:31:46",
                  person: "Kole Huey",
                },
                {
                  id: 2,
                  type: "Withdrawl",
                  amount: "2000",
                  note: "Funds for a new cvpi.",
                  date: "2022-07-13 18:31:46",
                  person: "Kole Huey",
                },
                {
                  id: 3,
                  type: "Withdrawl",
                  amount: "34520",
                  note: "Funds for a new cvpi.",
                  date: "2022-07-13 20:31:46",
                  person: "Kole Huey",
                },
                {
                  id: 4,
                  type: "Withdrawl",
                  amount: "2000",
                  note: "Funds for a new cvpi.",
                  date: "2022-07-13 18:31:46",
                  person: "Kole Huey",
                },
              ],
            },
            {
              id: 2,
              name: "Los Santos Police Department",
              type: "Business Account",
              accountnumber: 561341818,
              balance: 3000000,
              transactions: [
                {
                  id: 1,
                  type: "Withdrawl",
                  amount: "74863",
                  note: "Funds for a new charger.",
                  date: "2022-07-11 10:31:46",
                  person: "Kole Huey",
                },
              ],
            },
            {
              id: 3,
              name: "Los Santos Sheriffs Department",
              type: "Business Account",
              accountnumber: 561341819,
              balance: 3000000,
              transactions: [
                {
                  id: 1,
                  type: "Withdrawl",
                  amount: "45813",
                  note: "Funds for a new explorer.",
                  date: "2022-07-5 08:31:46",
                  person: "Kole Huey",
                },
              ],
            },
          ],
        },
    }
  },
  mutations: {
    setShow: (state, payload) => {
      state.show = payload
    }
  }
})