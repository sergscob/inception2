<template>
  <div id="app">
    <h1>Hello from Vue.js on Alpine!</h1>
    <h2>{{ counter }}</h2>
    <button @click="counter++">Increment</button>
  </div>
</template>

<script>

export default {
  components: {
  },
  props: {
    detail: Object
  },
  data() {
    return {
        counter: 0,
    };
  },
}
</script>

<style>
#app { font-family: Arial, sans-serif; padding: 20px; }
button {
    padding: 10px 20px;
    border-radius: 10px;
    border: 1px solid #ccc;
    background: #fff;
    cursor: pointer;
}
</style>