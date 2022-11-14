import { createStore } from 'vuex'

export default createStore({
  state() {
    return {
        show: false,
        title: "Fleeca Bank",
        characterName: "Kole Huey",
        cash: 0,
        isBank: false,
        accountTypes: [
          {
            id: 1,
            name: "Checking Account",
            icon: "credit_card",
            color: "purple",
            show: true,
            shareable: false,
            form: [
              { value: "", label: "Account Name", icon: "drive_file_rename_outline", name: "account_name"}
            ]
          },
          {
            id: 2,
            name: "Savings Account",
            icon: "savings",
            color: "teal",
            show: true,
            shareable: false,
            form: [
              { value: "", label: "Account Name", icon: "drive_file_rename_outline", name: "account_name"}
            ]
          },
          {
            id: 3,
            name: "Joint Account",
            icon: "credit_card",
            color: "teal",
            show: true,
            shareable: true,
            form: [
              { value: "", label: "Account Name", icon: "drive_file_rename_outline", name: "account_name"}
            ]
          },
          {
            id: 4,
            name: "Business Account",
            icon: "savings",
            color: "teal",
            show: false,
            shareable: true,
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
            isBankRequired: true,
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
            isBankRequired: false,
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
            isBankRequired: false,
            form: [
              { value: "", mask:"##########", prefix: "", label: "Account Number", icon: "wallet", name: "target_account" },
              { value: "", mask:"#############", prefix: "$", label: "Amount", icon: "attach_money", name: "amount" },
              { value: "", mask:"", prefix: "", label: "Note", icon: "note", name: "note" },
            ]
          },
        ],
        data: {
          accounts: [],
        },
    }
  },
  mutations: {
    setShow: (state, payload) => {
      state.show = payload
    }
  }
})