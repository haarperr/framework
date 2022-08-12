<template>
  <div v-if="show" @keyup.esc="closeMenu" class="absolute-center container">
    <q-layout view="lHh lpR lFr" style="min-height: 800px;">
      <q-header elevated class="bg-primary text-white">
        <q-toolbar>
          <q-toolbar-title>
            <span class="on-right">{{"Welcome Back " + characterName }}</span>
            <q-btn class="float-right" flat color="white" icon="close" @click="closeMenu"></q-btn>
            <span class="float-right">{{ title }}</span>
          </q-toolbar-title>
        </q-toolbar>
      </q-header>

      <q-drawer class="scroll hide-scrollbar bg-dark" :width="350" v-model="leftDrawerOpen" side="left" style="max-width:350px; height: 900px;">
        <q-toolbar elevated class="bg-primary text-white">
          <q-toolbar-title>
            Accounts
          </q-toolbar-title>
          <span class="text-white text-bold text-subtitle1">{{"Cash: $" + cash }}</span>
        </q-toolbar>

          <q-list>
            <div v-for="(account, index) in accounts" :key="account.id">
              <q-item clickable v-ripple :active="selectedAccount === index" @click="selectedAccount = index" active-class="active-account">
                <q-item-section no-wrap top lines="1">
                  <q-item-label class="text-weight-bold text-white" overline>{{ account.account_name }}</q-item-label>
                  <q-item-label class="text-white" caption>{{ accountTypes[account.account_type - 1].name + " - " + account.account_id}}</q-item-label>
                  <q-item-label caption class="text-weight-bolder text-white">{{ "$" + formatPrice(account.account_balance) }}</q-item-label>
                </q-item-section>
               <q-item-section side style="padding-top: 20px">
                  <div class="text-grey-8 q-gutter-xs">
                    <q-btn class="gt-xs" color="white" size="10px" flat dense round icon="delete" @click="openDeletePrompt()" />
                    <q-btn v-if="accountTypes[account.account_type - 1].shareable === true" class="gt-xs" color="white" size="10px" flat dense round icon="share" @click="openSharePrompt()" />
                  </div>
                </q-item-section>
              </q-item>
              <q-separator />
            </div>
          </q-list>
      </q-drawer>
      
      <q-page-container class="scroll hide-scrollbar" style="height: 800px; background-color: #121212">
        <div v-if="accounts.length > 0">
          <div class="q-pa-sm" v-for="transaction in accounts[selectedAccount].transactions" :key="transaction.id">
            <q-card class="text-white bg-dark" bordered>
              <q-card-section horizontal>
                <q-card-section class="q-pt-xs">
                  <div class="text-overline text-bold">{{ transactions[transaction.transaction_type - 1].name }}</div>
                  <div class="text-h5 q-mt-sm q-mb-xs">{{ formatPrice(transaction.transaction_amount) }}</div>
                  <div class="text-caption text-grey">
                    {{ transaction.transaction_note }}
                  </div>
                </q-card-section>
              </q-card-section>

              <q-separator class="bg-grey"/>

              <q-card-section>
                <q-chip color="orange-10" text-color="white" glossy icon="event">{{ formatTimestamp(transaction.transaction_date) }}</q-chip>
                <q-chip color="red" text-color="white" glossy icon="person">{{ transaction.transaction_person }}</q-chip>
                <q-chip color="green" v-if="transaction.transaction_to != null" text-color="white" glossy icon="savings">{{ "To " + transaction.transaction_to }}</q-chip>
                <q-chip color="green" v-if="transaction.transaction_from != null" text-color="white" glossy icon="savings">{{ "From " + transaction.transaction_from }}</q-chip>
              </q-card-section>
            </q-card>
          </div>
        </div>

        <q-dialog v-model="transactionPrompt" persistent>
          <q-card class="text-white bg-dark" style="min-width: 350px">
            <q-card-section>
              <div class="text-h6">{{ transactions[selectedTransaction].name }}</div>
            </q-card-section>
            <q-form @submit="submitTransaction">
              <q-card-section class="q-pt-none">
                <div v-for="input in transactions[selectedTransaction].form" :key="input">
                  <q-input dark stack-label label-color="white" autofocus v-model="input.value" :prefix="input.prefix" :mask="input.mask" :label="input.label">
                    <template v-slot:append>
                      <q-icon :name="input.icon" color="white" />
                    </template>
                  </q-input>
                </div>
              </q-card-section>

              <q-card-actions align="right" class="text-primary">
                <q-btn flat label="Cancel" v-close-popup />
                <q-btn flat label="Submit" type="submit" v-close-popup />
              </q-card-actions>
            </q-form>
          </q-card>
        </q-dialog>

        <q-dialog v-model="createPrompt" persistent>
          <q-card class="text-white bg-dark" style="min-width: 350px">
            <q-card-section>
              <div class="text-h6">Create Account</div>
            </q-card-section>
            <q-form @submit="onCreateAccount">
              <q-card-section class="q-pt-none">
                <div v-for="input in accountTypes[selectedCreateType].form" :key="input">
                  <q-input dark stack-label label-color="white" v-model="input.value" autofocus :label="input.label">
                    <template v-slot:append>
                      <q-icon :name="input.icon" color="white" />
                    </template>
                  </q-input>
                </div>
              </q-card-section>
              <q-card-actions align="right" class="text-primary">
                <q-btn flat label="Cancel" v-close-popup />
                <q-btn flat type="submit" label="Create" v-close-popup />
              </q-card-actions>
            </q-form>
          </q-card>
        </q-dialog>

        <q-dialog v-model="deletePrompt" persistent>
          <q-card class="text-white bg-dark" style="min-width: 350px">
            <q-card-section>
              <div class="text-h6">Delete Account</div>
            </q-card-section>
            <q-card-actions align="right" class="text-primary">
              <q-btn flat label="Cancel" v-close-popup />
              <q-btn flat @click="submitDelete" label="Delete" v-close-popup />
            </q-card-actions>
          </q-card>
        </q-dialog>

        <q-dialog v-model="sharePrompt" persistent>
          <q-card class="text-white bg-dark" style="min-width: 350px">
            <q-card-section>
              <div class="text-h6">Share Account</div>
            </q-card-section>
            <q-form @submit="submitShare">
              <q-card-section class="q-pt-none">
                <q-input dark stack-label label-color="white" v-model="shareID" autofocus label="StateID">
                  <template v-slot:append>
                    <q-icon name="person" color="white" />
                  </template>
                </q-input>
              </q-card-section>
              <q-card-actions align="right" class="text-primary">
                <q-btn flat label="Cancel" v-close-popup />
                <q-btn flat type="submit" label="Share" v-close-popup />
              </q-card-actions>
            </q-form>
          </q-card>
        </q-dialog>

        <q-page-sticky position="bottom-right" :offset="[18, 18]">
          <q-fab
            icon="add"
            direction="left"
            color="primary"
          >
            <div v-for="transaction in transactions" :key="transaction.id">
              <q-fab-action v-if="( transaction.isBankRequired === true && isBank === true ) || transaction.isBankRequired === false" label-position="right" :color="transaction.color" @click="openTransactionPrompt(); selectedTransaction = transaction.id - 1" :icon="transaction.icon" :label="transaction.name" />
            </div>
            <div v-for="accountType in accountTypes" :key="accountType.id">
              <q-fab-action v-if="accountType.show === true" label-position="right" :color="accountType.color" @click="openCreatePrompt(); selectedCreateType = accountType.id - 1" :icon="accountType.icon" :label="accountType.name" />
            </div>
          </q-fab>
        </q-page-sticky>
      </q-page-container>
    </q-layout>
  </div>
</template>

<script>
import { ref } from "vue";
import { computed } from "vue";
import { useStore } from "vuex";

export default {
  // <q-item-section avatar>
  //   <q-icon name="inbox" />
  // </q-item-section>
  setup () {
    const leftDrawerOpen = ref(true)
    const transactionPrompt = ref(false)
    const createPrompt = ref(false)
    const deletePrompt = ref(false)
    const sharePrompt = ref(false)
    const store = useStore()
    const accounts = computed(() => store.state.data.accounts)
    const show = computed(() => store.state.show)
    const title = computed(() => store.state.title)
    const isBank = computed(() => store.state.isBank)
    const characterName = computed(() => store.state.characterName)
    const accountTypes = computed(() => store.state.accountTypes)
    const transactions = computed(() => store.state.transactionTypes)
    const cash = computed(() => store.state.cash)
    return {
      selectedAccount: ref(0),
      selectedTransaction: ref(1),
      selectedCreateType: ref(1),
      shareID: "",
      moneyFormatForComponent: {
        decimal: '.',
        thousands: ',',
        prefix: '$ ',
        suffix: ' #',
        precision: 0,
        masked: true
      },
      accounts, show, title, accountTypes, characterName, transactions, isBank,
      leftDrawerOpen, transactionPrompt, createPrompt, cash, deletePrompt, sharePrompt,
      toggleLeftDrawer () {
        leftDrawerOpen.value = !leftDrawerOpen.value
      },
      openTransactionPrompt () {
        transactionPrompt.value = true
      },
      openCreatePrompt() {
        createPrompt.value = true
      },
      openDeletePrompt() {
        deletePrompt.value = true
      },
      openSharePrompt() {
        sharePrompt.value = true
      }
    }
  },
  mounted() {
    this.listener = window.addEventListener('message', (event) => {
      var data = event.data;

      if ( data.open != null ) {
        this.$store.state.show = data.open
      }

      if ( data.info ) {
        this.$store.state.title = data.info.bank
        this.$store.state.characterName = data.info.name
        this.$store.state.cash = data.info.cash
        this.$store.state.isBank = data.info.isBank
      }

      if ( data.commit ) {
        this.$store.state.data[data.type]=data.commit
      }
    });
  },
  computed: {
    
  },
  methods: {
    formatTimestamp(number)
    {
      return new Date(number).toLocaleString("en-US");
    },
    onCreateAccount () {
      let data = {}
      
      for(let input of this.accountTypes[this.selectedCreateType].form) {
        data[input.name] = input.value
      }

      data["type"] = this.accountTypes[this.selectedCreateType].id

      fetch(`http://banking/createAccount`, {
        body: JSON.stringify({ data: data }),
        method: "post",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        }
      })
    },
    submitTransaction() {
      let data = {}

      for(let input of this.transactions[this.selectedTransaction].form) {
        data[input.name] = input.value
      }
    
      data["account_id"] = this.accounts[this.selectedAccount].account_id
      data["type"] = this.transactions[this.selectedTransaction].id

      fetch(`http://banking/transaction`, {
        body: JSON.stringify({ data: data }),
        method: "post",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        }
      })

    },
    submitDelete() {
      let data = {}

      data["account_id"] = this.accounts[this.selectedAccount].account_id

      fetch(`http://banking/deleteAccount`, {
        body: JSON.stringify({ data: data }),
        method: "post",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        }
      })
    },
    submitShare() {
      let data = {}

      data["account_id"] = this.accounts[this.selectedAccount].account_id
      data["stateID"] = this.shareID

      fetch(`http://banking/shareAccount`, {
        body: JSON.stringify({ data: data }),
        method: "post",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        }
      })
    },
    formatPrice(value) {
        let val = (value/1).toFixed(2).replace(',', '.')
        return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    },
    formatDate(ts) {
      return new Date(ts * 1000).toLocaleString('en-US', { timeZone: 'UTC', timeZoneName: 'short'});
    },
    closeMenu() {
      fetch(`http://banking/closeMenu`, {
				method: 'post',
				body: JSON.stringify({}),
			})
    }
  }
}
</script>

<style lang="sass">
.active-account
  background: #1f8547

.container
  width: 1200px
  height: 800px

.transaction-card important
  width: 100%
  background: #000000
</style>