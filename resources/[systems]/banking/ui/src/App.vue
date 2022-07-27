<template>
  <div v-if="show" @keyup.esc="closeMenu" class="absolute-center container">
    <q-layout view="lHh lpR lFr" style="min-height: 800px;">
      <q-header elevated class="bg-primary text-white">
        <q-toolbar>
          <q-toolbar-title>
            <span class="on-right">{{"Welcome back " + characterName }}</span>
            <span class="float-right">{{ title }}</span>
          </q-toolbar-title>
        </q-toolbar>
      </q-header>

      <q-drawer class="scroll hide-scrollbar bg-dark" :width="350" v-model="leftDrawerOpen" side="left" style="max-width:800px; height: 900px;">
        <q-toolbar elevated class="bg-primary text-white">
          <q-toolbar-title>
            Accounts
          </q-toolbar-title>
        </q-toolbar>

          <q-list>
            <div v-for="account in accounts" :key="account.id">
              <q-item clickable v-ripple :active="selectedAccount === account.id" @click="selectedAccount = account.id" active-class="active-account">
                <q-item-section top lines="1">
                  <q-item-label class="text-weight-bold text-white" overline>{{ account.name }}</q-item-label>
                  <q-item-label class="text-white" caption>{{ account.type + " - " + account.accountnumber}}</q-item-label>
                  <q-item-label caption class="text-weight-bolder text-white">{{ "$" + formatPrice(account.balance) }}</q-item-label>
                </q-item-section>
                <q-item-section top side>
                  <div class="text-grey-8 q-gutter-xs">
                    <q-btn class="gt-xs" size="12px" flat dense round icon="add" @click="depositprompt = true" />
                    <q-btn class="gt-xs" size="12px" flat dense round icon="remove" @click="withdrawprompt = true" />
                    <q-btn class="gt-xs" size="12px" flat dense round icon="east" @click="transferprompt = true" />
                  </div>
                </q-item-section>
              </q-item>
              <q-separator />
            </div>
          </q-list>
      </q-drawer>
      
      <q-page-container class="scroll hide-scrollbar" style="height: 800px; background-color: #121212">
        <div class="q-pa-sm" v-for="transaction in accounts[selectedAccount - 1].transactions" :key="transaction.id">
          <q-card class="text-white bg-dark" bordered>
            <q-card-section horizontal>
              <q-card-section class="q-pt-xs">
                <div class="text-overline text-bold">{{ transaction.type }}</div>
                <div class="text-h5 q-mt-sm q-mb-xs">{{ formatPrice(transaction.amount) }}</div>
                <div class="text-caption text-grey">
                  {{ transaction.note }}
                </div>
              </q-card-section>
            </q-card-section>

            <q-separator class="bg-grey"/>

            <q-card-section>
              <q-chip color="orange-10" text-color="white" glossy icon="event">{{ transaction.date }}</q-chip>
              <q-chip color="red" text-color="white" glossy icon="person">{{ transaction.person }}</q-chip>
            </q-card-section>
          </q-card>
        </div>

        <q-dialog v-model="depositprompt" persistent>
          <q-card class="text-white bg-dark" style="min-width: 350px">
            <q-card-section>
              <div class="text-h6">Deposit</div>
            </q-card-section>
            <q-form @submit="onDeposit">
              <q-card-section class="q-pt-none">
                <q-input dark stack-label label-color="white" v-model="deposit" autofocus prefix="$" mask="#############" label="Amount">
                  <template v-slot:append>
                    <q-icon name="attach_money" color="white" />
                  </template>
                </q-input>
                <q-input dark stack-label label-color="white" v-model="note" autofocus label="Note">
                  <template v-slot:append>
                    <q-icon name="note" color="white" />
                  </template>
                </q-input>
              </q-card-section>

              <q-card-actions align="right" class="text-primary">
                <q-btn flat label="Cancel" v-close-popup />
                <q-btn flat label="Deposit" type="submit" v-close-popup />
              </q-card-actions>
            </q-form>
          </q-card>
        </q-dialog>
        <q-dialog v-model="withdrawprompt" persistent>
          <q-card class="text-white bg-dark" style="min-width: 350px">
            <q-card-section>
              <div class="text-h6">Withdraw</div>
            </q-card-section>
            <q-form @submit="onWithdraw">
              <q-card-section class="q-pt-none">
                <q-input dark stack-label label-color="white" v-model="withdraw" autofocus prefix="$" mask="#############" label="Amount">
                  <template v-slot:append>
                    <q-icon name="attach_money" color="white" />
                  </template>
                </q-input>
                <q-input dark stack-label label-color="white" v-model="note" autofocus label="Note">
                  <template v-slot:append>
                    <q-icon name="note" color="white" />
                  </template>
                </q-input>
              </q-card-section>

              <q-card-actions align="right" class="text-primary">
                <q-btn flat label="Cancel" v-close-popup />
                <q-btn flat label="Withdraw" type="submit" v-close-popup />
              </q-card-actions>
            </q-form>
          </q-card>
        </q-dialog>
        <q-dialog v-model="transferprompt" persistent>
          <q-card class="text-white bg-dark" style="min-width: 350px">
            <q-card-section>
              <div class="text-h6">Account Transfer</div>
            </q-card-section>
            <q-form @submit="onTransfer">
              <q-card-section class="q-pt-none">
                <q-input dark stack-label label-color="white" v-model="transferaccount" autofocus mask="########" label="Account Number">
                  <template v-slot:append>
                    <q-icon name="wallet" color="white" />
                  </template>
                </q-input>
                <q-input dark stack-label label-color="white" v-model="transferamount" autofocus prefix="$" mask="#############" label="Transfer Amount">
                  <template v-slot:append>
                    <q-icon name="attach_money" color="white" />
                  </template>
                </q-input>
                <q-input dark stack-label label-color="white" v-model="note" autofocus label="Note">
                  <template v-slot:append>
                    <q-icon name="note" color="white" />
                  </template>
                </q-input>
              </q-card-section>

              <q-card-actions align="right" class="text-primary">
                <q-btn flat label="Cancel" v-close-popup />
                <q-btn flat type="submit" label="Transfer" v-close-popup />
              </q-card-actions>
            </q-form>
          </q-card>
        </q-dialog>
        <q-dialog v-model="createaccountprompt" persistent>
          <q-card class="text-white bg-dark" style="min-width: 350px">
            <q-card-section>
              <div class="text-h6">Create Account</div>
            </q-card-section>
            <q-form @submit="onCreateAccount">
              <q-card-section class="q-pt-none">
                <q-input dark stack-label label-color="white" v-model="createAccountName" autofocus label="Account Name">
                  <template v-slot:append>
                    <q-icon name="drive_file_rename_outline" color="white" />
                  </template>
                </q-input>
              </q-card-section>
              <q-card-actions align="right" class="text-primary">
                <q-btn flat label="Cancel" v-close-popup />
                <q-btn flat type="submit" label="Create" v-close-popup />
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
            <div v-for="accounttype in accounttypes" :key="accounttype.id">
              <q-fab-action label-position="right" color="primary" @click="createaccountprompt = true" :icon="accounttype.icon" :label="accounttype.name" />
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
    const store = useStore()
    const accounts = computed(() => store.state.data.accounts)
    const show = computed(() => store.state.show)
    const title = computed(() => store.state.title)
    const characterName = computed(() => store.state.characterName)
    const accounttypes = computed(() => store.state.accounttypes)
    return {
      depositprompt: ref(false),
      deposit: ref(''),
      withdrawprompt: ref(false),
      withdraw: ref(''),
      transferprompt: ref(false),
      transferamount: ref(''),
      transferaccount: ref(''),
      createaccountprompt: ref(false),
      createAccountName: ref(''),
      selectedAccount: ref(1),
      note: ref(''),
      moneyFormatForComponent: {
        decimal: '.',
        thousands: ',',
        prefix: '$ ',
        suffix: ' #',
        precision: 0,
        masked: true
      },
      accounts, show, title, accounttypes, characterName,
      leftDrawerOpen,
      toggleLeftDrawer () {
        leftDrawerOpen.value = !leftDrawerOpen.value
      },
    }
  },
  mounted() {
    this.listener = window.addEventListener('message', (event) => {
      var data = event.data;

      if ( data.open != null ) {
        this.$store.state.show = data.open
        console.log(`Opening ${data.open}!`)
      }

      if ( data.info ) {
        this.$store.state.title = data.info.bank
        this.$store.state.characterName = data.info.name
      }
    });
  },
  computed: {
    
  },
  methods: {
    onCreateAccount (evt) {
      const formData = new FormData(evt.target)
      const data = []

      for (const [ name, value ] of formData.entries()) {
        data.push({
          name,
          value
        })
      }

      fetch(`https://banking//createAccount`, {
        body: JSON.stringify(data),
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        }
      })
    },
    onTransfer (evt) {
      const formData = new FormData(evt.target)
      const data = []

      for (const [ name, value ] of formData.entries()) {
        data.push({
          name,
          value
        })
      }

      fetch(`https://banking//transfer`, {
        body: JSON.stringify(data),
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        }
      })
    },
    onDeposit (evt) {
      const formData = new FormData(evt.target)
      const data = []

      for (const [ name, value ] of formData.entries()) {
        data.push({
          name,
          value
        })
      }

      fetch(`https://banking//deposit`, {
        body: JSON.stringify(data),
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        }
      })
    },
    onWithdraw (evt) {
      const formData = new FormData(evt.target)
      const data = []

      for (const [ name, value ] of formData.entries()) {
        data.push({
          name,
          value
        })
      }

      fetch(`https://banking//withdraw`, {
        body: JSON.stringify(data),
        method: "POST",
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
      fetch(`http://banking/toggle`, {
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