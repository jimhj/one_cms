# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# AdminUser.create(SEEDDATA['admin'])

config                  = SiteConfig.new
config.site_name        = '健康私房话'
config.site_slogan      = '传播健康知识，倡导健康生活'
config.site_title       = 'H4传播健康知识，倡导健康生活'
config.site_keywords    = '健康私房话,H4健康网,H4'
config.site_description = '健康私房话H4专注健康养生、健康饮食、生活小常识、健康小常识、保健养生知识、健康小知识、男性健康、女性健康等健康服务领域，传播健康知识，倡导健康生活！让健康伴随一生！'
config.brand_color      = '#ef758e !default'
config.text_color       = '#454545'
config.contact_email    = 'service@h4.com.cn'
config.bd_email         = 'bd@h4.com.cn' 
config.icp              = '京ICP备11031391号'
config.copyright        = 'Copyright 2008-2018 健康私房话 www.h4.com.cn 版权所有 京ICP备11031391号'
config.declare          = '<p>声明：健康私房话所发布的内容来源于网友分享，仅出于分享健康知识，并不意味着赞同其观点或证实其描述。文章内容仅供参考，具体治疗及选购请咨询医生或相关专业人士。</p><p>若有相关问题，请联系 <a class="contact-us" href="mailto:service@h4.com.cn"><i class="fa fa-envelope"></i> service@h4.com.cn</a></p>'
config.save!

p config.errors.full_messages