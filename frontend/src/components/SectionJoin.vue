<template lang="pug">
.section
  .section-header
    h1 Don't have a testnet address?

  .section-main
    btn(type="anchor" href="https://stride.zone" value="" size="lg" target="_blank" icon="wifi_tethering")
</template>

<script>
import Btn from "@nylira/vue-button";
export default {
  name: "section-join",
  components: {
    Btn
  }
};
</script>
