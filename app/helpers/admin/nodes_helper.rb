module Admin
  module NodesHelper
    def node_options
      result = []
      items = Node.roots || []
      items.each do |root|
        result += root.class.associate_parents(root.self_and_descendants).map do |i|
          option = "<option value='#{i.id}'"
          if @node.parent_id == i.id
            option += " selected=selected"
          end

          if i.level.zero?
            option += ">#{i.name}"
          else
            option += " style='text-indent: #{i.level*10}px'>"
            option += "﹂#{i.name}"
          end

          option += "</option>"
        end
      end
      result
    end
  end
end
