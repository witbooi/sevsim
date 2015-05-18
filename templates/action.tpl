<% disabled = a.available == true ? '' : 'disabled="disabled"' %>
<input type="button" value="<%= a.title.replace(/\"/g,'&quot;') %>" data-action-id="<%= a.id %>" id="action-<%= a.id %>-btn" class="action-btn" <%= disabled %> />
