defmodule OnsplekkieNlWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use OnsplekkieNlWeb, :html

  embed_templates "page_html/*"

  @doc "Renders a block of text, splitting blank lines into separate paragraphs."
  attr :text, :string, default: ""
  attr :class, :string, default: "mb-4 leading-relaxed text-ink/80"

  def paragraphs(assigns) do
    ~H"""
    <%= for para <- split_paragraphs(@text) do %>
      <p class={@class}>{para}</p>
    <% end %>
    """
  end

  @doc "A page banner with a background image, title and optional subtitle."
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :image, :any, default: nil

  def page_hero(assigns) do
    ~H"""
    <section class="relative flex min-h-[38vh] items-center justify-center overflow-hidden bg-[#20301f]">
      <img
        :if={@image}
        src={@image.path}
        alt={@image.alt}
        data-parallax="0.12"
        class="absolute inset-0 h-full w-full object-cover opacity-60"
      />
      <div class="relative mx-auto max-w-3xl px-4 py-20 text-center text-white" data-animate="up">
        <h1 class="font-heading text-4xl font-bold drop-shadow sm:text-5xl">{@title}</h1>
        <p :if={@subtitle} class="mt-4 text-lg text-white/90 drop-shadow">{@subtitle}</p>
      </div>
    </section>
    """
  end

  @doc "Splits a text value into a list of paragraphs on blank lines."
  def split_paragraphs(nil), do: []

  def split_paragraphs(text) do
    text
    |> String.split(~r/\n\s*\n/, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  @doc "Splits a newline-separated value into a list of trimmed lines."
  def lines(nil), do: []

  def lines(text) do
    text
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
