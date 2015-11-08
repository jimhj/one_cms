module Admin
  module NodesHelper
    def node_list(children, reserve = '')
      children.each do |child|
        reserve += %Q(
          <div class="node-item"><div class="inner clearfix">
            <div class="pull-left expander"><a href="#"><img src="#{image_path('admin/contract.gif')}" /></a></div>
            <div class="pull-left node-name">#{child.name} [id: #{child.id}]</div>
            <div class="pull-right ops">
              <a href="#">编辑</a><span>|</span>
              <a href="#{new_admin_node_path(parent_id: child.id)}">添加子栏目</a><span>|</span>
              <a href="#">删除</a>
            </div>
          </div>
        )
        reserve+="</div>" * child.level
        if child.children.count > 0
          node_list(child.children, reserve)
        end
      end
      reserve
    end
  end
end
