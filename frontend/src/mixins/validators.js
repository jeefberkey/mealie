export const validators = {
  data() {
    return {
      emailRule: v =>
        !v ||
        /^[^@\s]+@[^@\s.]+.[^@.\s]+$/.test(v) ||
       this.$t('user.e-mail-must-be-valid'),

      existsRule: value => !!value || this.$t('general.field-required'),

      minRule: v =>
        v.length >= 8 || this.$t('user.use-8-characters-or-more-for-your-password'),
    };
  },
};
