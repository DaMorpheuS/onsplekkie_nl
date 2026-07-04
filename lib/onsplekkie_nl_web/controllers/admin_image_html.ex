defmodule OnsplekkieNlWeb.AdminImageHTML do
  use OnsplekkieNlWeb, :html

  embed_templates "admin_image_html/*"

  attr :collection, :map, required: true

  def add_form(assigns) do
    ~H"""
    <form
      action={~p"/admin/images"}
      method="post"
      enctype="multipart/form-data"
      class="flex flex-wrap items-end gap-3 rounded-xl border-2 border-dashed border-gray-300 bg-gray-50 p-4"
    >
      <input type="hidden" name="_csrf_token" value={get_csrf_token()} />
      <input type="hidden" name="collection" value={@collection.key} />
      <div class="flex-1">
        <label class="mb-1 block text-xs font-semibold text-ink/70">Nieuwe afbeelding</label>
        <input
          type="file"
          name="image[file]"
          accept="image/*"
          required
          class="block w-full text-sm file:mr-3 file:rounded-full file:border-0 file:bg-brand file:px-4 file:py-1.5 file:font-semibold file:text-white"
        />
      </div>
      <div class="flex-1">
        <label class="mb-1 block text-xs font-semibold text-ink/70">Omschrijving (alt)</label>
        <input
          type="text"
          name="image[alt]"
          class="w-full rounded-lg border border-gray-300 px-3 py-1.5 text-sm"
        />
      </div>
      <button
        type="submit"
        class="rounded-full bg-brand px-5 py-2 text-sm font-semibold text-white hover:bg-brand-dark"
      >
        Toevoegen
      </button>
    </form>
    """
  end
end
