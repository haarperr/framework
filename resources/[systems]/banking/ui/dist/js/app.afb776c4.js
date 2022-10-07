(function(){"use strict";var e={2927:function(e,t,a){var o=a(5102),n=a(9269),l=a(3201);const i={class:"on-right"},c={class:"float-right"},s={class:"text-white text-bold text-subtitle1"},r={class:"text-grey-8 q-gutter-xs"},u={key:0},m={class:"text-overline text-bold"},d={class:"text-h5 q-mt-sm q-mb-xs"},p={class:"text-caption text-grey"},f={class:"text-h6"},h=(0,n._)("div",{class:"text-h6"},"Create Account",-1),w=(0,n._)("div",{class:"text-h6"},"Delete Account",-1),b=(0,n._)("div",{class:"text-h6"},"Share Account",-1);function g(e,t,a,g,_,y){const k=(0,n.up)("q-btn"),v=(0,n.up)("q-toolbar-title"),x=(0,n.up)("q-toolbar"),W=(0,n.up)("q-header"),T=(0,n.up)("q-item-label"),q=(0,n.up)("q-item-section"),C=(0,n.up)("q-item"),D=(0,n.up)("q-separator"),A=(0,n.up)("q-list"),S=(0,n.up)("q-drawer"),Z=(0,n.up)("q-card-section"),P=(0,n.up)("q-chip"),V=(0,n.up)("q-card"),Q=(0,n.up)("q-icon"),U=(0,n.up)("q-input"),F=(0,n.up)("q-card-actions"),N=(0,n.up)("q-form"),O=(0,n.up)("q-dialog"),z=(0,n.up)("q-fab-action"),H=(0,n.up)("q-fab"),j=(0,n.up)("q-page-sticky"),B=(0,n.up)("q-page-container"),$=(0,n.up)("q-layout"),I=(0,n.Q2)("ripple"),K=(0,n.Q2)("close-popup");return g.show?((0,n.wg)(),(0,n.iD)("div",{key:0,onKeyup:t[8]||(t[8]=(0,o.D2)(((...e)=>y.closeMenu&&y.closeMenu(...e)),["esc"])),class:"absolute-center container"},[(0,n.Wm)($,{view:"lHh lpR lFr",style:{"min-height":"800px"}},{default:(0,n.w5)((()=>[(0,n.Wm)(W,{elevated:"",class:"bg-primary text-white"},{default:(0,n.w5)((()=>[(0,n.Wm)(x,null,{default:(0,n.w5)((()=>[(0,n.Wm)(v,null,{default:(0,n.w5)((()=>[(0,n._)("span",i,(0,l.zw)("Welcome Back "+g.characterName),1),(0,n.Wm)(k,{class:"float-right",flat:"",color:"white",icon:"close",onClick:y.closeMenu},null,8,["onClick"]),(0,n._)("span",c,(0,l.zw)(g.title),1)])),_:1})])),_:1})])),_:1}),(0,n.Wm)(S,{class:"scroll hide-scrollbar bg-dark",width:350,modelValue:g.leftDrawerOpen,"onUpdate:modelValue":t[2]||(t[2]=e=>g.leftDrawerOpen=e),side:"left",style:{"max-width":"350px",height:"900px"}},{default:(0,n.w5)((()=>[(0,n.Wm)(x,{elevated:"",class:"bg-primary text-white"},{default:(0,n.w5)((()=>[(0,n.Wm)(v,null,{default:(0,n.w5)((()=>[(0,n.Uk)(" Accounts ")])),_:1}),(0,n._)("span",s,(0,l.zw)("Cash: $"+g.cash),1)])),_:1}),(0,n.Wm)(A,null,{default:(0,n.w5)((()=>[((0,n.wg)(!0),(0,n.iD)(n.HY,null,(0,n.Ko)(g.accounts,((e,a)=>((0,n.wg)(),(0,n.iD)("div",{key:e.id},[(0,n.wy)(((0,n.wg)(),(0,n.j4)(C,{clickable:"",active:g.selectedAccount===a,onClick:e=>g.selectedAccount=a,"active-class":"active-account"},{default:(0,n.w5)((()=>[(0,n.Wm)(q,{"no-wrap":"",top:"",lines:"1"},{default:(0,n.w5)((()=>[(0,n.Wm)(T,{class:"text-weight-bold text-white",overline:""},{default:(0,n.w5)((()=>[(0,n.Uk)((0,l.zw)(e.account_name),1)])),_:2},1024),(0,n.Wm)(T,{class:"text-white",caption:""},{default:(0,n.w5)((()=>[(0,n.Uk)((0,l.zw)(g.accountTypes[e.account_type-1].name+" - "+e.account_id),1)])),_:2},1024),(0,n.Wm)(T,{caption:"",class:"text-weight-bolder text-white"},{default:(0,n.w5)((()=>[(0,n.Uk)((0,l.zw)("$"+y.formatPrice(e.account_balance)),1)])),_:2},1024)])),_:2},1024),(0,n.Wm)(q,{side:"",style:{"padding-top":"20px"}},{default:(0,n.w5)((()=>[(0,n._)("div",r,[(0,n.Wm)(k,{class:"gt-xs",color:"white",size:"10px",flat:"",dense:"",round:"",icon:"delete",onClick:t[0]||(t[0]=e=>g.openDeletePrompt())}),!0===g.accountTypes[e.account_type-1].shareable?((0,n.wg)(),(0,n.j4)(k,{key:0,class:"gt-xs",color:"white",size:"10px",flat:"",dense:"",round:"",icon:"share",onClick:t[1]||(t[1]=e=>g.openSharePrompt())})):(0,n.kq)("",!0)])])),_:2},1024)])),_:2},1032,["active","onClick"])),[[I]]),(0,n.Wm)(D)])))),128))])),_:1})])),_:1},8,["modelValue"]),(0,n.Wm)(B,{class:"scroll hide-scrollbar",style:{height:"800px","background-color":"#121212"}},{default:(0,n.w5)((()=>[null!=g.accounts[g.selectedAccount]?((0,n.wg)(),(0,n.iD)("div",u,[((0,n.wg)(!0),(0,n.iD)(n.HY,null,(0,n.Ko)(g.accounts[g.selectedAccount].transactions,(e=>((0,n.wg)(),(0,n.iD)("div",{class:"q-pa-sm",key:e.id},[(0,n.Wm)(V,{class:"text-white bg-dark",bordered:""},{default:(0,n.w5)((()=>[(0,n.Wm)(Z,{horizontal:""},{default:(0,n.w5)((()=>[(0,n.Wm)(Z,{class:"q-pt-xs"},{default:(0,n.w5)((()=>[(0,n._)("div",m,(0,l.zw)(g.transactions[e.transaction_type-1].name),1),(0,n._)("div",d,(0,l.zw)(y.formatPrice(e.transaction_amount)),1),(0,n._)("div",p,(0,l.zw)(e.transaction_note),1)])),_:2},1024)])),_:2},1024),(0,n.Wm)(D,{class:"bg-grey"}),(0,n.Wm)(Z,null,{default:(0,n.w5)((()=>[(0,n.Wm)(P,{color:"orange-10","text-color":"white",glossy:"",icon:"event"},{default:(0,n.w5)((()=>[(0,n.Uk)((0,l.zw)(y.formatTimestamp(e.transaction_date)),1)])),_:2},1024),(0,n.Wm)(P,{color:"red","text-color":"white",glossy:"",icon:"person"},{default:(0,n.w5)((()=>[(0,n.Uk)((0,l.zw)(e.transaction_person),1)])),_:2},1024),null!=e.transaction_to?((0,n.wg)(),(0,n.j4)(P,{key:0,color:"green","text-color":"white",glossy:"",icon:"savings"},{default:(0,n.w5)((()=>[(0,n.Uk)((0,l.zw)("To "+e.transaction_to),1)])),_:2},1024)):(0,n.kq)("",!0),null!=e.transaction_from?((0,n.wg)(),(0,n.j4)(P,{key:1,color:"green","text-color":"white",glossy:"",icon:"savings"},{default:(0,n.w5)((()=>[(0,n.Uk)((0,l.zw)("From "+e.transaction_from),1)])),_:2},1024)):(0,n.kq)("",!0)])),_:2},1024)])),_:2},1024)])))),128))])):(0,n.kq)("",!0),(0,n.Wm)(O,{modelValue:g.transactionPrompt,"onUpdate:modelValue":t[3]||(t[3]=e=>g.transactionPrompt=e),persistent:""},{default:(0,n.w5)((()=>[(0,n.Wm)(V,{class:"text-white bg-dark",style:{"min-width":"350px"}},{default:(0,n.w5)((()=>[(0,n.Wm)(Z,null,{default:(0,n.w5)((()=>[(0,n._)("div",f,(0,l.zw)(g.transactions[g.selectedTransaction].name),1)])),_:1}),(0,n.Wm)(N,{onSubmit:y.submitTransaction},{default:(0,n.w5)((()=>[(0,n.Wm)(Z,{class:"q-pt-none"},{default:(0,n.w5)((()=>[((0,n.wg)(!0),(0,n.iD)(n.HY,null,(0,n.Ko)(g.transactions[g.selectedTransaction].form,(e=>((0,n.wg)(),(0,n.iD)("div",{key:e},[(0,n.Wm)(U,{dark:"","stack-label":"","label-color":"white",autofocus:"",modelValue:e.value,"onUpdate:modelValue":t=>e.value=t,prefix:e.prefix,mask:e.mask,label:e.label},{append:(0,n.w5)((()=>[(0,n.Wm)(Q,{name:e.icon,color:"white"},null,8,["name"])])),_:2},1032,["modelValue","onUpdate:modelValue","prefix","mask","label"])])))),128))])),_:1}),(0,n.Wm)(F,{align:"right",class:"text-primary"},{default:(0,n.w5)((()=>[(0,n.wy)((0,n.Wm)(k,{flat:"",label:"Cancel"},null,512),[[K]]),(0,n.wy)((0,n.Wm)(k,{flat:"",label:"Submit",type:"submit"},null,512),[[K]])])),_:1})])),_:1},8,["onSubmit"])])),_:1})])),_:1},8,["modelValue"]),(0,n.Wm)(O,{modelValue:g.createPrompt,"onUpdate:modelValue":t[4]||(t[4]=e=>g.createPrompt=e),persistent:""},{default:(0,n.w5)((()=>[(0,n.Wm)(V,{class:"text-white bg-dark",style:{"min-width":"350px"}},{default:(0,n.w5)((()=>[(0,n.Wm)(Z,null,{default:(0,n.w5)((()=>[h])),_:1}),(0,n.Wm)(N,{onSubmit:y.onCreateAccount},{default:(0,n.w5)((()=>[(0,n.Wm)(Z,{class:"q-pt-none"},{default:(0,n.w5)((()=>[((0,n.wg)(!0),(0,n.iD)(n.HY,null,(0,n.Ko)(g.accountTypes[g.selectedCreateType].form,(e=>((0,n.wg)(),(0,n.iD)("div",{key:e},[(0,n.Wm)(U,{dark:"","stack-label":"","label-color":"white",modelValue:e.value,"onUpdate:modelValue":t=>e.value=t,autofocus:"",label:e.label},{append:(0,n.w5)((()=>[(0,n.Wm)(Q,{name:e.icon,color:"white"},null,8,["name"])])),_:2},1032,["modelValue","onUpdate:modelValue","label"])])))),128))])),_:1}),(0,n.Wm)(F,{align:"right",class:"text-primary"},{default:(0,n.w5)((()=>[(0,n.wy)((0,n.Wm)(k,{flat:"",label:"Cancel"},null,512),[[K]]),(0,n.wy)((0,n.Wm)(k,{flat:"",type:"submit",label:"Create"},null,512),[[K]])])),_:1})])),_:1},8,["onSubmit"])])),_:1})])),_:1},8,["modelValue"]),(0,n.Wm)(O,{modelValue:g.deletePrompt,"onUpdate:modelValue":t[5]||(t[5]=e=>g.deletePrompt=e),persistent:""},{default:(0,n.w5)((()=>[(0,n.Wm)(V,{class:"text-white bg-dark",style:{"min-width":"350px"}},{default:(0,n.w5)((()=>[(0,n.Wm)(Z,null,{default:(0,n.w5)((()=>[w])),_:1}),(0,n.Wm)(F,{align:"right",class:"text-primary"},{default:(0,n.w5)((()=>[(0,n.wy)((0,n.Wm)(k,{flat:"",label:"Cancel"},null,512),[[K]]),(0,n.wy)((0,n.Wm)(k,{flat:"",onClick:y.submitDelete,label:"Delete"},null,8,["onClick"]),[[K]])])),_:1})])),_:1})])),_:1},8,["modelValue"]),(0,n.Wm)(O,{modelValue:g.sharePrompt,"onUpdate:modelValue":t[7]||(t[7]=e=>g.sharePrompt=e),persistent:""},{default:(0,n.w5)((()=>[(0,n.Wm)(V,{class:"text-white bg-dark",style:{"min-width":"350px"}},{default:(0,n.w5)((()=>[(0,n.Wm)(Z,null,{default:(0,n.w5)((()=>[b])),_:1}),(0,n.Wm)(N,{onSubmit:y.submitShare},{default:(0,n.w5)((()=>[(0,n.Wm)(Z,{class:"q-pt-none"},{default:(0,n.w5)((()=>[(0,n.Wm)(U,{dark:"","stack-label":"","label-color":"white",modelValue:g.shareID,"onUpdate:modelValue":t[6]||(t[6]=e=>g.shareID=e),autofocus:"",label:"StateID"},{append:(0,n.w5)((()=>[(0,n.Wm)(Q,{name:"person",color:"white"})])),_:1},8,["modelValue"])])),_:1}),(0,n.Wm)(F,{align:"right",class:"text-primary"},{default:(0,n.w5)((()=>[(0,n.wy)((0,n.Wm)(k,{flat:"",label:"Cancel"},null,512),[[K]]),(0,n.wy)((0,n.Wm)(k,{flat:"",type:"submit",label:"Share"},null,512),[[K]])])),_:1})])),_:1},8,["onSubmit"])])),_:1})])),_:1},8,["modelValue"]),(0,n.Wm)(j,{position:"bottom-right",offset:[18,18]},{default:(0,n.w5)((()=>[(0,n.Wm)(H,{icon:"add",direction:"left",color:"primary"},{default:(0,n.w5)((()=>[((0,n.wg)(!0),(0,n.iD)(n.HY,null,(0,n.Ko)(g.transactions,(e=>((0,n.wg)(),(0,n.iD)("div",{key:e.id},[!0===e.isBankRequired&&!0===g.isBank||!1===e.isBankRequired?((0,n.wg)(),(0,n.j4)(z,{key:0,"label-position":"right",color:e.color,onClick:t=>{g.openTransactionPrompt(),g.selectedTransaction=e.id-1},icon:e.icon,label:e.name},null,8,["color","onClick","icon","label"])):(0,n.kq)("",!0)])))),128)),((0,n.wg)(!0),(0,n.iD)(n.HY,null,(0,n.Ko)(g.accountTypes,(e=>((0,n.wg)(),(0,n.iD)("div",{key:e.id},[!0===e.show?((0,n.wg)(),(0,n.j4)(z,{key:0,"label-position":"right",color:e.color,onClick:t=>{g.openCreatePrompt(),g.selectedCreateType=e.id-1},icon:e.icon,label:e.name},null,8,["color","onClick","icon","label"])):(0,n.kq)("",!0)])))),128))])),_:1})])),_:1})])),_:1})])),_:1})],32)):(0,n.kq)("",!0)}var _=a(6237),y=a(6957),k={setup(){const e=(0,_.iH)(!0),t=(0,_.iH)(!1),a=(0,_.iH)(!1),o=(0,_.iH)(!1),l=(0,_.iH)(!1),i=(0,y.oR)(),c=(0,n.Fl)((()=>i.state.data.accounts)),s=(0,n.Fl)((()=>i.state.show)),r=(0,n.Fl)((()=>i.state.title)),u=(0,n.Fl)((()=>i.state.isBank)),m=(0,n.Fl)((()=>i.state.characterName)),d=(0,n.Fl)((()=>i.state.accountTypes)),p=(0,n.Fl)((()=>i.state.transactionTypes)),f=(0,n.Fl)((()=>i.state.cash));return{selectedAccount:(0,_.iH)(0),selectedTransaction:(0,_.iH)(1),selectedCreateType:(0,_.iH)(1),shareID:"",moneyFormatForComponent:{decimal:".",thousands:",",prefix:"$ ",suffix:" #",precision:0,masked:!0},accounts:c,show:s,title:r,accountTypes:d,characterName:m,transactions:p,isBank:u,leftDrawerOpen:e,transactionPrompt:t,createPrompt:a,cash:f,deletePrompt:o,sharePrompt:l,toggleLeftDrawer(){e.value=!e.value},openTransactionPrompt(){t.value=!0},openCreatePrompt(){a.value=!0},openDeletePrompt(){o.value=!0},openSharePrompt(){l.value=!0}}},mounted(){this.listener=window.addEventListener("message",(e=>{var t=e.data;null!=t.open&&(this.$store.state.show=t.open),t.info&&(this.$store.state.title=t.info.bank,this.$store.state.characterName=t.info.name,this.$store.state.cash=t.info.cash,this.$store.state.isBank=t.info.isBank),t.commit&&(this.$store.state.data[t.type]=t.commit)}))},computed:{},methods:{formatTimestamp(e){return new Date(e).toLocaleString("en-US")},onCreateAccount(){let e={};for(let t of this.accountTypes[this.selectedCreateType].form)e[t.name]=t.value;e["type"]=this.accountTypes[this.selectedCreateType].id,fetch("http://banking/createAccount",{body:JSON.stringify({data:e}),method:"post",headers:{"Content-Type":"application/json; charset=UTF-8"}})},submitTransaction(){let e={};for(let t of this.transactions[this.selectedTransaction].form)e[t.name]=t.value;e["account_id"]=this.accounts[this.selectedAccount].account_id,e["type"]=this.transactions[this.selectedTransaction].id,fetch("http://banking/transaction",{body:JSON.stringify({data:e}),method:"post",headers:{"Content-Type":"application/json; charset=UTF-8"}})},submitDelete(){let e={};e["account_id"]=this.accounts[this.selectedAccount].account_id,fetch("http://banking/deleteAccount",{body:JSON.stringify({data:e}),method:"post",headers:{"Content-Type":"application/json; charset=UTF-8"}})},submitShare(){let e={};e["account_id"]=this.accounts[this.selectedAccount].account_id,e["stateID"]=this.shareID,fetch("http://banking/shareAccount",{body:JSON.stringify({data:e}),method:"post",headers:{"Content-Type":"application/json; charset=UTF-8"}})},formatPrice(e){let t=(e/1).toFixed(2).replace(",",".");return t.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",")},formatDate(e){return new Date(1e3*e).toLocaleString("en-US",{timeZone:"UTC",timeZoneName:"short"})},closeMenu(){fetch("http://banking/closeMenu",{method:"post",body:JSON.stringify({})})}}},v=a(7617),x=a(2446),W=a(7454),T=a(366),q=a(8623),C=a(4686),D=a(5092),A=a(2146),S=a(5246),Z=a(2278),P=a(3712),V=a(4492),Q=a(6974),U=a(8055),F=a(9501),N=a(1384),O=a(9680),z=a(3276),H=a(1125),j=a(4633),B=a(4333),$=a(8579),I=a(9917),K=a(118),R=a(8108),L=a(8819),M=a(1410),J=a.n(M);const Y=(0,v.Z)(k,[["render",g]]);var E=Y;J()(k,"components",{QLayout:x.Z,QHeader:W.Z,QToolbar:T.Z,QToolbarTitle:q.Z,QBtn:C.Z,QDrawer:D.Z,QList:A.Z,QItem:S.Z,QItemSection:Z.Z,QItemLabel:P.Z,QSeparator:V.Z,QPageContainer:Q.Z,QCard:U.Z,QCardSection:F.Z,QChip:N.Z,QDialog:O.Z,QForm:z.Z,QInput:H.Z,QIcon:j.Z,QCardActions:B.Z,QPageSticky:$.Z,QFab:I.Z,QFabAction:K.Z}),J()(k,"directives",{Ripple:R.Z,ClosePopup:L.Z});var G=a(6001),X={config:{dark:"false"},plugins:{}},ee=(0,y.MT)({state(){return{show:!1,title:"Fleeca Bank",characterName:"Kole Huey",cash:0,isBank:!1,accountTypes:[{id:1,name:"Checking Account",icon:"credit_card",color:"purple",show:!0,shareable:!1,form:[{value:"",label:"Account Name",icon:"drive_file_rename_outline",name:"account_name"}]},{id:2,name:"Savings Account",icon:"savings",color:"teal",show:!0,shareable:!1,form:[{value:"",label:"Account Name",icon:"drive_file_rename_outline",name:"account_name"}]},{id:3,name:"Joint Account",icon:"savings",color:"teal",show:!1,shareable:!0,form:[{value:"",label:"Account Name",icon:"drive_file_rename_outline",name:"account_name"}]},{id:4,name:"Business Account",icon:"savings",color:"teal",show:!1,shareable:!0,form:[{value:"",label:"Account Name",icon:"drive_file_rename_outline",name:"account_name"}]}],transactionTypes:[{id:1,name:"Deposit",icon:"remove",color:"red",isBankRequired:!0,form:[{value:"",mask:"#############",prefix:"$",label:"Amount",icon:"attach_money",name:"amount"},{value:"",mask:"",prefix:"",label:"Note",icon:"note",name:"note"}]},{id:2,name:"Withdraw",icon:"add",color:"orange",isBankRequired:!1,form:[{value:"",mask:"#############",prefix:"$",label:"Amount",icon:"attach_money",name:"amount"},{value:"",mask:"",prefix:"",label:"Note",icon:"note",name:"note"}]},{id:3,name:"Transfer",icon:"arrow_forward",color:"blue",isBankRequired:!1,form:[{value:"",mask:"##########",prefix:"",label:"Account Number",icon:"wallet",name:"target_account"},{value:"",mask:"#############",prefix:"$",label:"Amount",icon:"attach_money",name:"amount"},{value:"",mask:"",prefix:"",label:"Note",icon:"note",name:"note"}]}],data:{accounts:[]}}},mutations:{setShow:(e,t)=>{e.show=t}}});const te=(0,o.ri)(E);te.use(G.Z,X).use(ee).mount("#app")}},t={};function a(o){var n=t[o];if(void 0!==n)return n.exports;var l=t[o]={exports:{}};return e[o](l,l.exports,a),l.exports}a.m=e,function(){var e=[];a.O=function(t,o,n,l){if(!o){var i=1/0;for(u=0;u<e.length;u++){o=e[u][0],n=e[u][1],l=e[u][2];for(var c=!0,s=0;s<o.length;s++)(!1&l||i>=l)&&Object.keys(a.O).every((function(e){return a.O[e](o[s])}))?o.splice(s--,1):(c=!1,l<i&&(i=l));if(c){e.splice(u--,1);var r=n();void 0!==r&&(t=r)}}return t}l=l||0;for(var u=e.length;u>0&&e[u-1][2]>l;u--)e[u]=e[u-1];e[u]=[o,n,l]}}(),function(){a.n=function(e){var t=e&&e.__esModule?function(){return e["default"]}:function(){return e};return a.d(t,{a:t}),t}}(),function(){a.d=function(e,t){for(var o in t)a.o(t,o)&&!a.o(e,o)&&Object.defineProperty(e,o,{enumerable:!0,get:t[o]})}}(),function(){a.g=function(){if("object"===typeof globalThis)return globalThis;try{return this||new Function("return this")()}catch(e){if("object"===typeof window)return window}}()}(),function(){a.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)}}(),function(){var e={143:0};a.O.j=function(t){return 0===e[t]};var t=function(t,o){var n,l,i=o[0],c=o[1],s=o[2],r=0;if(i.some((function(t){return 0!==e[t]}))){for(n in c)a.o(c,n)&&(a.m[n]=c[n]);if(s)var u=s(a)}for(t&&t(o);r<i.length;r++)l=i[r],a.o(e,l)&&e[l]&&e[l][0](),e[l]=0;return a.O(u)},o=self["webpackChunkui"]=self["webpackChunkui"]||[];o.forEach(t.bind(null,0)),o.push=t.bind(null,o.push.bind(o))}();var o=a.O(void 0,[998],(function(){return a(2927)}));o=a.O(o)})();
//# sourceMappingURL=app.afb776c4.js.map