import { createStore } from 'vuex'

export default createStore({
  state() {
    return {
        show: false,
        title: "Fleeca Bank",
        characterName: "Kole Huey",
        accounttypes: [
          {
            id: 1,
            name: "Checking Account",
            icon: "credit_card",
          },
          {
            id: 2,
            name: "Savings Account",
            icon: "savings",
          },
        ],
        transactiontypes: [
          {
            id: 1,
            name: "Withdrawl",
          },
          {
            id: 2,
            name: "Deposit",
          },
          {
            id: 3,
            name: "Transfer",
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