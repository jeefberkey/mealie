<template>
  <v-card>
    <v-card-title class="headline">
      {{ $t("settings.theme.theme-settings") }}
    </v-card-title>
    <v-divider></v-divider>
    <v-card-text>
      <h2 class="mt-4 mb-1">{{ $t("settings.theme.dark-mode") }}</h2>
      <p>
        {{
          $t(
            "settings.theme.choose-how-mealie-looks-to-you-set-your-theme-preference-to-follow-your-system-settings-or-choose-to-use-the-light-or-dark-theme"
          )
        }}
      </p>
      <v-row dense align="center">
        <v-col cols="6">
          <v-btn-toggle
            v-model="selectedDarkMode"
            color="primary "
            mandatory
            @change="setStoresDarkMode"
          >
            <v-btn value="system">
              <v-icon>mdi-desktop-tower-monitor</v-icon>
              <span class="ml-1" v-show="$vuetify.breakpoint.smAndUp">
                {{ $t("settings.theme.default-to-system") }}
              </span>
            </v-btn>

            <v-btn value="light">
              <v-icon>mdi-white-balance-sunny</v-icon>
              <span class="ml-1" v-show="$vuetify.breakpoint.smAndUp">
                {{ $t("settings.theme.light") }}
              </span>
            </v-btn>

            <v-btn value="dark">
              <v-icon>mdi-weather-night</v-icon>
              <span class="ml-1" v-show="$vuetify.breakpoint.smAndUp">
                {{ $t("settings.theme.dark") }}
              </span>
            </v-btn>
          </v-btn-toggle>
        </v-col>
      </v-row></v-card-text
    >
    <v-divider></v-divider>
    <v-card-text>
      <h2 class="mt-1 mb-1">{{ $t("settings.theme.theme") }}</h2>
      <p>
        {{
          $t(
            "settings.theme.select-a-theme-from-the-dropdown-or-create-a-new-theme-note-that-the-default-theme-will-be-served-to-all-users-who-have-not-set-a-theme-preference"
          )
        }}
      </p>

      <v-row dense align-content="center" v-if="selectedTheme.colors">
        <v-col>
          <ColorPickerDialog
            :button-text="$t('settings.theme.primary')"
            v-model="selectedTheme.colors.primary"
          />
        </v-col>
        <v-col>
          <ColorPickerDialog
            :button-text="$t('settings.theme.secondary')"
            v-model="selectedTheme.colors.secondary"
          />
        </v-col>
        <v-col>
          <ColorPickerDialog
            :button-text="$t('settings.theme.accent')"
            v-model="selectedTheme.colors.accent"
          />
        </v-col>
        <v-col>
          <ColorPickerDialog
            :button-text="$t('settings.theme.success')"
            v-model="selectedTheme.colors.success"
          />
        </v-col>
        <v-col>
          <ColorPickerDialog
            :button-text="$t('settings.theme.info')"
            v-model="selectedTheme.colors.info"
          />
        </v-col>
        <v-col>
          <ColorPickerDialog
            :button-text="$t('settings.theme.warning')"
            v-model="selectedTheme.colors.warning"
          />
        </v-col>
        <v-col>
          <ColorPickerDialog
            :button-text="$t('settings.theme.error')"
            v-model="selectedTheme.colors.error"
          />
        </v-col>
      </v-row>
    </v-card-text>

    <v-card-text>
      <v-row>
        <v-col
          cols="12"
          sm="12"
          md="6"
          lg="4"
          xl="3"
          v-for="theme in availableThemes"
          :key="theme.name"
        >
          <ThemeCard
            :theme="theme"
            :current="selectedTheme.name == theme.name ? true : false"
            @delete="getAllThemes"
          />
        </v-col>
      </v-row>
    </v-card-text>

    <v-card-actions>
      <NewThemeDialog @new-theme="appendTheme" class="mt-1" />
      <v-spacer></v-spacer>
      <v-btn color="success" @click="saveThemes" class="mr-2">
        <v-icon left> mdi-content-save </v-icon>
        {{ $t("general.save") }}
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import { api } from "@/api";
import ColorPickerDialog from "@/components/Admin/Theme/ColorPickerDialog";
import NewThemeDialog from "@/components/Admin/Theme/NewThemeDialog";
import ThemeCard from "@/components/Admin/Theme/ThemeCard";

export default {
  components: {
    ColorPickerDialog,
    NewThemeDialog,
    ThemeCard,
  },
  data() {
    return {
      selectedDarkMode: "system",
      availableThemes: [],
    };
  },
  async mounted() {
    await this.getAllThemes();

    this.selectedDarkMode = this.$store.getters.getDarkMode;
  },

  computed: {
    selectedTheme() {
      return this.$store.getters.getActiveTheme;
    },
  },

  methods: {
    async getAllThemes() {
      this.availableThemes = await api.themes.requestAll();
    },
    /**
     * Create the new Theme and select it.
     */
    async appendTheme(NewThemeDialog) {
      await api.themes.create(NewThemeDialog);
      this.availableThemes.push(NewThemeDialog);
      this.$store.commit("setTheme", NewThemeDialog);
    },
    setStoresDarkMode() {
      this.$store.commit("setDarkMode", this.selectedDarkMode);
    },
    /**
     * This will save the current colors and make the selected theme live.
     */
    async saveThemes() {
      await api.themes.update(
        this.selectedTheme.name,
        this.selectedTheme.colors
      );
    },
  },
};
</script>

<style>
</style>

