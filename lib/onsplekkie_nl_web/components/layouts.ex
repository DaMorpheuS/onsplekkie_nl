defmodule OnsplekkieNlWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use OnsplekkieNlWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://phoenix.hexdocs.pm/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar px-4 sm:px-6 lg:px-8">
      <div class="flex-1">
        <a href="/" class="flex-1 flex w-fit items-center gap-2">
          <img src={~p"/images/logo.svg"} width="36" />
          <span class="text-sm font-semibold">v{Application.spec(:phoenix, :vsn)}</span>
        </a>
      </div>
      <div class="flex-none">
        <ul class="flex flex-column px-1 space-x-4 items-center">
          <li>
            <a href="https://phoenixframework.org/" class="btn btn-ghost">Website</a>
          </li>
          <li>
            <a href="https://github.com/phoenixframework/phoenix" class="btn btn-ghost">GitHub</a>
          </li>
          <li>
            <.theme_toggle />
          </li>
          <li>
            <a href="https://phoenix.hexdocs.pm/overview.html" class="btn btn-primary">
              Get Started <span aria-hidden="true">&rarr;</span>
            </a>
          </li>
        </ul>
      </div>
    </header>

    <main class="px-4 py-20 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-2xl space-y-4">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  The public website chrome: top contact bar, main navigation and footer.
  Pages render their content inside the default slot.
  """
  attr :flash, :map, default: %{}
  attr :settings, :map, required: true, doc: "map of content settings"
  attr :active, :atom, default: nil, doc: "the active nav item"
  attr :locale, :string, default: "nl", doc: "the active language"
  slot :inner_block, required: true

  def site(assigns) do
    ~H"""
    <.flash_group flash={@flash} />

    <div class="flex min-h-screen flex-col">
      <div class="bg-brand text-white text-sm">
        <div class="mx-auto flex max-w-6xl flex-wrap items-center justify-end gap-x-6 gap-y-1 px-4 py-2">
          <a
            href={"tel:#{String.replace(@settings["contact_phone"] || "", " ", "")}"}
            class="inline-flex items-center gap-2 hover:text-white/80"
          >
            <.icon name="hero-phone-micro" class="size-4" />
            {@settings["contact_phone"]}
          </a>
          <a
            href={"mailto:#{@settings["contact_email"]}"}
            class="inline-flex items-center gap-2 hover:text-white/80"
          >
            <.icon name="hero-envelope-micro" class="size-4" />
            {@settings["contact_email"]}
          </a>
        </div>
      </div>

      <header class="sticky top-0 z-40 border-b border-black/5 bg-white/95 backdrop-blur">
        <nav class="mx-auto flex max-w-6xl flex-wrap items-center justify-between gap-4 px-4 py-3">
          <a href={~p"/"} class="flex items-center gap-3">
            <img src={~p"/images/site/logoa.png"} alt={@settings["site_title"]} class="h-12 w-auto" />
          </a>
          <ul class="flex flex-wrap items-center gap-x-6 gap-y-1 text-[15px] font-semibold font-heading">
            <.nav_link to={~p"/"} label={t(@locale, "nav.home")} active={@active == :home} />
            <.nav_link
              to={~p"/accommodatie"}
              label={t(@locale, "nav.accommodatie")}
              active={@active == :accommodatie}
            />
            <.nav_link
              to={~p"/omgeving"}
              label={t(@locale, "nav.omgeving")}
              active={@active == :omgeving}
            />
            <.nav_link
              to={~p"/reserveren"}
              label={t(@locale, "nav.reserveren")}
              active={@active == :reserveren}
            />
            <.nav_link
              to={~p"/contact"}
              label={t(@locale, "nav.contact")}
              active={@active == :contact}
            />
            <li>
              <.language_picker locale={@locale} />
            </li>
            <li>
              <a
                href={~p"/reserveren"}
                class="rounded-full bg-brand px-5 py-2 text-white transition hover:bg-brand-dark"
              >
                {t(@locale, "nav.book_now")}
              </a>
            </li>
          </ul>
        </nav>
      </header>

      <main class="flex-1">
        {render_slot(@inner_block)}
      </main>

      <footer class="bg-[#20301f] text-white/80">
        <div class="mx-auto grid max-w-6xl gap-10 px-4 py-14 sm:grid-cols-2 lg:grid-cols-3">
          <div>
            <img
              src={~p"/images/site/logoa.png"}
              alt={@settings["site_title"]}
              class="mb-4 h-14 w-auto brightness-0 invert"
            />
            <p class="text-sm leading-relaxed">{@settings["footer_tagline"]}</p>
          </div>

          <div>
            <h4 class="mb-4 font-heading text-lg font-semibold text-white">
              {t(@locale, "footer.pages")}
            </h4>
            <ul class="space-y-2 text-sm">
              <li>
                <a href={~p"/accommodatie"} class="hover:text-white">
                  {t(@locale, "nav.accommodatie")}
                </a>
              </li>
              <li>
                <a href={~p"/omgeving"} class="hover:text-white">{t(@locale, "nav.omgeving")}</a>
              </li>
              <li>
                <a href={~p"/reserveren"} class="hover:text-white">
                  {t(@locale, "nav.reserveren")}
                </a>
              </li>
              <li>
                <a href={~p"/contact"} class="hover:text-white">
                  {t(@locale, "footer.contact_location")}
                </a>
              </li>
            </ul>
          </div>

          <div>
            <h4 class="mb-4 font-heading text-lg font-semibold text-white">
              {t(@locale, "footer.reserveren")}
            </h4>
            <p class="mb-4 text-sm leading-relaxed">{@settings["footer_reserveren_text"]}</p>
            <a
              href={~p"/reserveren"}
              class="inline-block rounded-full bg-brand px-5 py-2 text-sm font-semibold text-white transition hover:bg-brand-dark"
            >
              {t(@locale, "footer.reserveren_button")}
            </a>
          </div>
        </div>

        <div class="border-t border-white/10">
          <div class="mx-auto flex max-w-6xl flex-col items-center justify-between gap-2 px-4 py-5 text-xs text-white/50 sm:flex-row">
            <p>
              © {Date.utc_today().year} {@settings["site_title"]} — {@settings["contact_address"]}
            </p>
            <p>{@settings["footer_credit"]}</p>
          </div>
        </div>
      </footer>

      <%!-- Image lightbox (controlled by assets/js/app.js) --%>
      <div id="op-lightbox" class="op-lightbox" role="dialog" aria-modal="true" aria-hidden="true">
        <button
          type="button"
          data-lb-close
          aria-label={t(@locale, "lb.close")}
          class="op-lb-btn absolute right-4 top-4"
        >
          <.icon name="hero-x-mark" class="size-7" />
        </button>
        <button
          type="button"
          data-lb-prev
          aria-label={t(@locale, "lb.prev")}
          class="op-lb-btn op-lb-arrow absolute left-3 top-1/2 -translate-y-1/2 sm:left-6"
        >
          <.icon name="hero-chevron-left" class="size-7" />
        </button>
        <img data-lb-image src="" alt="" class="op-lb-img" />
        <button
          type="button"
          data-lb-next
          aria-label={t(@locale, "lb.next")}
          class="op-lb-btn op-lb-arrow absolute right-3 top-1/2 -translate-y-1/2 sm:right-6"
        >
          <.icon name="hero-chevron-right" class="size-7" />
        </button>
        <div class="op-lb-counter">
          <span data-lb-current>1</span> / <span data-lb-total>1</span>
        </div>
      </div>
    </div>
    """
  end

  attr :to, :string, required: true
  attr :label, :string, required: true
  attr :active, :boolean, default: false

  defp nav_link(assigns) do
    ~H"""
    <li>
      <a
        href={@to}
        class={[
          "border-b-2 pb-0.5 transition hover:text-brand",
          @active && "border-brand text-brand",
          !@active && "border-transparent text-ink"
        ]}
      >
        {@label}
      </a>
    </li>
    """
  end

  attr :locale, :string, required: true

  defp language_picker(assigns) do
    ~H"""
    <div class="flex items-center gap-1.5">
      <a
        :for={code <- OnsplekkieNlWeb.I18n.locales()}
        href={~p"/taal/#{code}"}
        title={OnsplekkieNlWeb.I18n.language_name(code)}
        aria-label={OnsplekkieNlWeb.I18n.language_name(code)}
        class={[
          "block h-5 w-7 overflow-hidden rounded-[3px] shadow-sm ring-1 ring-black/10 transition",
          @locale == code && "opacity-100 outline outline-2 outline-brand outline-offset-1",
          @locale != code && "opacity-55 hover:opacity-100"
        ]}
      >
        <.flag code={code} />
      </a>
    </div>
    """
  end

  attr :code, :string, required: true

  defp flag(%{code: "nl"} = assigns) do
    ~H"""
    <svg viewBox="0 0 9 6" class="h-full w-full" aria-hidden="true">
      <rect width="9" height="6" fill="#21468B" />
      <rect width="9" height="4" fill="#fff" />
      <rect width="9" height="2" fill="#AE1C28" />
    </svg>
    """
  end

  defp flag(%{code: "de"} = assigns) do
    ~H"""
    <svg viewBox="0 0 5 3" class="h-full w-full" aria-hidden="true">
      <rect width="5" height="3" fill="#FFCE00" />
      <rect width="5" height="2" fill="#D00" />
      <rect width="5" height="1" fill="#000" />
    </svg>
    """
  end

  defp flag(%{code: "en"} = assigns) do
    ~H"""
    <svg viewBox="0 0 60 30" class="h-full w-full" aria-hidden="true">
      <clipPath id="uk-s"><path d="M0,0 v30 h60 v-30 z" /></clipPath>
      <clipPath id="uk-t">
        <path d="M30,15 h30 v15 z v15 h-30 z h-30 v-15 z v-15 h30 z" />
      </clipPath>
      <g clip-path="url(#uk-s)">
        <path d="M0,0 v30 h60 v-30 z" fill="#012169" />
        <path d="M0,0 L60,30 M60,0 L0,30" stroke="#fff" stroke-width="6" />
        <path d="M0,0 L60,30 M60,0 L0,30" clip-path="url(#uk-t)" stroke="#C8102E" stroke-width="4" />
        <path d="M30,0 v30 M0,15 h60" stroke="#fff" stroke-width="10" />
        <path d="M30,0 v30 M0,15 h60" stroke="#C8102E" stroke-width="6" />
      </g>
    </svg>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={
          show(".phx-client-error #client-error")
          |> JS.remove_attribute("hidden", to: ".phx-client-error #client-error")
        }
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={
          show(".phx-server-error #server-error")
          |> JS.remove_attribute("hidden", to: ".phx-server-error #server-error")
        }
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 [[data-theme-source=system]_&]:!left-0 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end

  @doc """
  Chrome for the /admin backend: a top bar with navigation and the content slot.
  """
  attr :flash, :map, default: %{}
  attr :active, :atom, default: nil
  slot :inner_block, required: true

  def admin(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <div class="min-h-screen bg-gray-100 text-gray-800">
      <header class="bg-[#20301f] text-white">
        <div class="mx-auto flex max-w-6xl flex-wrap items-center justify-between gap-4 px-4 py-3">
          <a href={~p"/admin"} class="font-heading text-lg font-bold">
            Ons Plekkie <span class="font-normal text-white/60">· Beheer</span>
          </a>
          <nav class="flex flex-wrap items-center gap-x-5 gap-y-1 text-sm font-semibold">
            <.admin_link to={~p"/admin"} label="Dashboard" active={@active == :dashboard} />
            <.admin_link to={~p"/admin/content"} label="Teksten" active={@active == :content} />
            <.admin_link to={~p"/admin/images"} label="Afbeeldingen" active={@active == :images} />
            <.admin_link to={~p"/admin/inbox"} label="Aanvragen" active={@active == :inbox} />
            <a href={~p"/"} target="_blank" class="text-white/70 hover:text-white">Bekijk site ↗</a>
            <.link href={~p"/admin/logout"} method="delete" class="text-white/70 hover:text-white">
              Uitloggen
            </.link>
          </nav>
        </div>
      </header>
      <main class="mx-auto max-w-6xl px-4 py-10">
        {render_slot(@inner_block)}
      </main>
    </div>
    """
  end

  attr :to, :string, required: true
  attr :label, :string, required: true
  attr :active, :boolean, default: false

  defp admin_link(assigns) do
    ~H"""
    <a
      href={@to}
      class={["hover:text-white", @active && "text-brand-light", !@active && "text-white/80"]}
    >
      {@label}
    </a>
    """
  end
end
