<% disabled = a.available ? '' : 'disabled="disabled"' %>
<input type="button" value="<%= a.title %>" data-action-id="<%= a.id %>" id="action-<%= a.id %>" class="action-btn" <%= disabled %> />
