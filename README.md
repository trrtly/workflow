## 简介

目前基于gitflow+jenkins+k8s持续集成、部署的流程中，还有许多需要优化修改的地方，

## 目录
- 1 [当前流程](#1-当前流程)
    - 1.1 [开发人员视角下的流程](#11-开发人员视角下的流程)
    - 1.2 [jenkins构建流程](#12-jenkins构建流程)

### 1 当前流程
#### 1.1 开发人员视角下的流程
- 开发人员fork项目主仓库
- 开发人员在develop分支进行本地开发，完成后推送至fork后的远程仓库
- 开发人员向项目主仓库develop分支发起一个pull request请求
- 小组组长合并pull request请求，web钩子自动触发[jenkins构建流程](#12-jenkins构建流程)
- 测试人员对测试环境进行测试，并提出issue
- 开发人员针对测试提出的issue进行修复，完成后推送至fork后的远程仓库
- 开发人员向项目主仓库develop分支发起一个pull request请求
- 小组组长合并pull request请求，web钩子自动触发jenkins构建流程
- 测试人员完成测试，通知产品，产品确认测试覆盖了需求所有功能测试用例，通知开发人员上线
- 小组组长向项目主仓库master分支发起一个pull request请求


#### 1.2 jenkins构建流程
- 