## 简介

目前基于 gitflow+jenkins+k8s 持续集成、部署的流程中，还有许多需要优化修改的地方，

## 目录
- 1 [当前流程](#1-当前流程)
    - 1.1 [开发人员视角下的流程](#11-开发人员视角下的流程)
    - 1.2 [jenkins 构建流程](#12-jenkins-构建流程)
- 2 [存在的问题](#2-存在的问题)
    - 2.1 [gitflow 工作流](#21-gitflow-工作流)
    - 2.2 [ci、cd 流程中的问题](#22-ci、cd-流程中的问题)
- 3 [简化后的流程](#3-简化后的流程)

### 1 当前流程
#### 1.1 开发人员视角下的流程
- 1.1.1 开发人员 fork 项目主仓库
- 1.1.2 开发人员在 develop 分支进行本地开发，完成后推送至 fork 后的远程仓库
- 1.1.3 开发人员向项目主仓库 develop 分支发起一个 pull request 请求
- 1.1.4 小组组长合并 pull request 请求，web 钩子自动触发[jenkins构建流程](#12-jenkins-构建流程)
- 1.1.5 测试人员对测试环境进行测试，并提出 issue
- 1.1.6 开发人员针对测试提出的 issue 进行修复，完成后推送至fork后的远程仓库
- 1.1.7 开发人员向项目主仓库 develop 分支发起一个 pull request 请求
- 1.1.8 小组组长合并 pull request 请求，web 钩子自动触发 jenkins 构建流程
- 1.1.9 测试人员完成测试，通知产品，产品确认测试覆盖了需求所有功能测试用例，通知开发人员上线
- 1.1.10 小组组长向项目主仓库 master 分支发起一个 pull request 请求，并合并该请求
- 1.1.11 小组组长为本次发布打 tag 号，并填写 changeLog，web 钩子自动触发[jenkins构建流程](#12-jenkins-构建流程)


#### 1.2 jenkins 构建流程
- 1.2.1 接收仓库推送的web钩子信息，根据分支（develop、master）及动作（pull_request、publish）触发相应任务
- 1.2.2 检查工作空间是否存在对应项目的git仓库，不存在则 clone 此仓库，否则 pull 此仓库的更新
- 1.2.3 检测项目根目录是否存在　composer.json　文件，存在则安装 composer　依赖包
- 1.2.4 拷贝项目对应环境配置文件至项目目录
- 1.2.5 根据项目名构建 docker 镜像　并打上标签：对应的 tag 号(发布生产环境)，或本次构建的　BUILD_ID (发布测试环境)，
- 1.2.6 将构建完成的镜像推送至对应环境的私有仓库
- 1.2.7 删除本地构建的镜像
- 1.2.8 如果是测试环境，则通知 k8s 滚动，否则通知运维发布

### 2 存在的问题
#### 2.1 gitflow　工作流
##### 2.1.1 gitflow 开发中存在的问题
目前项目采用　`gitflow`　管理分支，并借鉴 `githubflow` 引入 fork、 pull request 解决多人团队协作及 code review，参考：[Git Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)、[A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)、[githubflow](https://guides.github.com/introduction/flow/)
- 在开发中发现团队人员对 `gitflow` 、`githubflow` 不熟悉造成操作失误，部分人员刚从 `svn` 切换至 `git`，遇到冲突、分支合并等问题常常不知所措。
- git commit 信息没有形成统一的规范，造成提交历史信息杂乱无章

##### 2.1.2 解决方案

###### 流程优化，取消 fork
- 开发人员基于主仓库 develop　分支新建功能分支 feature/example 完成开发，并提交至主仓库对应功能分支 origin/example
- 测试对对应功能分支 origin/example 进行测试，提 issue
- 开发人员解决 issue，并推送至　origin/example
- 对应功能分支 origin/example 完成测试后开发人员向主仓库 develop　分支发起 pull request　请求，等待组长合并
- 组长根据[代码规范](http://git.epweike.net:3000/epwk/laravel_code_specification)审查代码，合并请求，功能分支合并至 develop　分支，测试进行 origin/develop 集成测试
- develop、master　分支仅允许通过其他分支发起 pull request提交代码
- pull request　仅组长能合并（由于 gogs 不支持只针对 pr 分配权限，这里只能通过组员自觉遵守）

###### 制定一品威客的 gitflow 工作流规范
- 采用[约定式提交规范](https://www.conventionalcommits.org/zh/v1.0.0-beta.3/)约定commit信息
- 参考 [gitflow](https://nvie.com/posts/a-successful-git-branching-model/)、[githubflow](https://guides.github.com/introduction/flow/)，制定一品威客`gitflow`
- [git 简明教程](http://rogerdudler.github.io/git-guide/index.zh.html)


#### 2.2 ci、cd 流程中的问题
##### 2.2.1 存在的问题
###### 目前 ci、cd　采用 `jenkins` + `shell`脚本，参考[jenkins官网](https://jenkins.io/zh/)，存在许多问题：
- 构建用时太长，普遍在3-10分钟左右，由于部分项目依赖的服务较多，需构建多个镜像（例如 larave=nginx+php-fpm+crontab+queue），目前jenkins构建任务是串行执行的，导致构建用时太长。
- 未集成单元测试、及代码风格检测，目前代码风格检查使用 git pre-commit 钩子，项目提交多的时检测时间过长。
- 测试环境仅对应dev分支，无法实现多 feature　分支并行开发情况下，并行测试的功能。
- 测试环境 jenkins　与生产环境 jenkins　分开部署，一次发布中人工参与流程过多
- 每次合并请求及版本发布需要重复填写 changeLog

##### 2.2.2 解决方案
- 选用 Drone 替换 jenkins 作为　ci cd 工具，前者可实现多任务并行执行，插件即 docker 镜像的方式方便集成单元测试及代码风格检测等构建功能，参考[dron github](https://github.com/drone/drone)
- 引入语义化发布工具(比如：[semantic-release](https://semantic-release.gitbook.io/semantic-release/)),简化发布流程，由　ci　工具自动发布 release

### 3 简化后的流程
取消 fork

- 开发人员从主仓库 origin/develop　分支 checkout　自己的功能分支 feature/example
- 开发人员在本地完成　feature/example 功能开发后 push 至　origin feature/example　分支，镜像测试
- ci 运行单元测试、代码风格检测等构建步骤，并构建镜像 test.epweike.net:example
- 功能开发完成后，开发成员向 develop 分支 发起 pull request ， ci 运行单元测试、代码风格检测等构建步骤
- 小组组长 merge pull request， ci 运行单元测试、代码风格检测等构建步骤，并构建镜像　test.epweike.net:develop
- 运维人员从 develop 向 master 发起 pull request，ci 运行单元测试，并构建镜像 test.epweike.net:release
- 运维人员 merge pull request， ci 执行单元测试、代码风格检测等构建步骤，并运行语义化发布工具(比如：[semantic-release](https://semantic-release.gitbook.io/semantic-release/)),自动发布 release,生成 changeLog
- release 再次触发ci 构建生产环境 Docker 镜像test.epweike.net:1.0.0