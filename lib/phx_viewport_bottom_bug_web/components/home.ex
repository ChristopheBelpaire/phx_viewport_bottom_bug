defmodule PhxViewportBottomBugWeb.HomeComponent do
  use Phoenix.LiveView
  use PhxViewportBottomBugWeb, :html

  def render(assigns) do
    ~H"""
    <ul class="flex flex-wrap text-sm font-medium text-center text-gray-500 border-b border-gray-200 dark:border-gray-700 dark:text-gray-400">
      <li class="mr-2">
        <.link patch={~p"/?tab=tab1"} aria-current="page" class={tab_selected("tab1", @tab)}>
          Tab 1
        </.link>
      </li>
      <li class="mr-2">
        <.link patch={~p"/?tab=tab2"} class={tab_selected("tab2", @tab)}>Tab 2</.link>
      </li>
    </ul>
    <%= if @tab == "tab1" do %>
      Click on Tab 2 and scroll
    <% else %>
      If you clicked on the tab, scroll won't work, if you refresh the page scroll will work
      <table class="table is-hoverable is-fullwidth">
        <thead>
          <tr>
            <th>Id</th>
          </tr>
        </thead>
        <tbody id="items" phx-update="stream" phx-viewport-bottom="next-page">
          <tr :for={{dom_id, item} <- @streams.items} id={dom_id}>
            <td><%= item.id %></td>
          </tr>
        </tbody>
      </table>
    <% end %>
    """
  end

  defp tab_selected(tab, tab),
    do:
      "inline-block p-4 text-blue-600 bg-gray-100 rounded-t-lg active dark:bg-gray-800 dark:text-blue-500"

  defp tab_selected(_, _),
    do:
      "inline-block p-4 rounded-t-lg hover:text-gray-600 hover:bg-gray-50 dark:hover:bg-gray-800 dark:hover:text-gray-300"

  def mount(_params, _, socket) do
    socket = socket
    |> stream_configure(:items, dom_id: &"#{&1.id}")
    {:ok, assign(socket, :tab, "tab1")}
  end

  def handle_params(%{"tab" => "tab2"}, _path, socket) do
    socket = socket
    |> stream(:items, Enum.map(1..100, &%{id: &1}), reset: true)
    {:noreply, assign(socket, :tab, "tab2")}
  end

  def handle_params(%{"tab" => tab}, _path, socket) do
    {:noreply, assign(socket, :tab, tab)}
  end

  def handle_params(%{}, _path, socket) do
    socket = socket
    {:noreply, assign(socket, :tab, "tab1")}
  end

  def handle_event("next-page", %{"id" => id}, socket) do
    id = String.to_integer(id)
    socket = socket |> stream(:items, Enum.map(id..(id + 100), &%{id: &1}))
    {:noreply, socket}
  end
end
