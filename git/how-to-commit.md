# `git commit` 消息格式规范

严格规范 `git commit` 消息填写格式，有助于提高项目历史信息的可读性。并且，`git commit` 消息将作为项目版本发布的 `change log`，在 ci 流程中使用「语义化发布工具」自动生成。

## 目录

- [关于「能愿动词」的使用](#关于能愿动词的使用)
- [约定式提交规范](#约定式提交规范)
  - [「头部」](#「头部」)
    - [「类型」](#「类型」)
    - [「作用域」](#「作用域」)
    - [「描述」](#「描述」)
    - [头部示例](#头部示例)
  - [「正文」](#「正文」)
  - [「脚注」](#「脚注」)
- [为什么使用约定式提交](#为什么使用约定式提交)
- [FAQ](#FAQ)
- [参考文档](#参考文档)

## 关于「能愿动词」的使用

为了避免歧义，文档大量使用了「能愿动词」，对应的解释如下：

* `必须 (MUST)`：绝对，严格遵循，请照做，无条件遵守；
* `一定不可 (MUST NOT)`：禁令，严令禁止；
* `应该 (SHOULD)` ：强烈建议这样做，但是不强求；
* `不该 (SHOULD NOT)`：强烈不建议这样做，但是不强求；
* `可以 (MAY)` 和 `可选 (OPTIONAL)` ：选择性高一点，在这个文档内，此词语使用较少；

> 参见：[RFC 2119](http://www.ietf.org/rfc/rfc2119.txt)

## 约定式提交规范

每个 `git commit` 消息由「头部」，「正文」和「脚注」构成。其中，「头部」格式比较特殊，包含「类型」，「作用域」和「描述」三部分：

---
```
<类型>(<作用域>): <描述>
// 空一行
[正文]
// 空一行
[脚注]
```
---

消息结构遵守如下约定：

* 「头部」是 `必须` 的，「正文」和「脚注」是 `可选` 的
* 「头部」中的「类型」和「描述」是 `必须` 的，「作用域」是 `可选` 的
* 任何一行 `commit` 消息 `一定不可` 超过 100 个字符。这是为了便于在各个 `Git` 服务及工具中便于阅读

### 「头部」

#### 「类型」

「类型」用于说明 `commit` 的类别，`必须` 是以下列表中的一种：

* **fix**: 「类型」为 `fix` 的提交在代码库中修复了一个 `bug`，这和语义化版本中的 [`PATCH`](https://semver.org/#summary) 相对应
* **feat**: 「类型」为 `feat` 的提交表示在代码库中新增了一个功能，这和语义化版本中的 [`MINOR`](https://semver.org/#summary) 相对应
* **docs**: 仅文档的修改(`documentation`）
* **style**: 不影响代码含义的代码修改（空格，格式化，缺少分号，等等）
* **refactor**: 既不是修复 `bug` 也不是新增功能的代码修改
* **test**: 添加缺少的「单元测试」，或更正已存在的「单元测试」
* **perf**: 对当前实现进行改进，提升性能的代码修改
* **chore**: 对构建过程或辅助工具和依赖库的更改（如自动文档生成工具、CI 构建工具，配置和脚本）

**还原**

如果当前 `commit` 是用以撤销以前的 `commit`，则 `必须` 以 `revert:` 开头，后面跟着被撤销 `commit` 的「头部」

示例：

```
revert: feat(user.login): 添加用户登录功能
```

#### 「作用域」

「作用域」用以说明 `commit` 影响的范围，比如路由、中间件、公共函数、功能模块等等，视项目不同而不同，当影响的范围有多个时候，可以使用 *，当仅涉及某一功能模块下的子模块时，`应该` 以 `.` 分割（参考：[angular 提交历史](https://github.com/angular/angular.js/commit/e500fb6ddb859cf172d06739fda7492730576de1)）。

示例：
```
user.login
```

#### 「描述」

「描述」是 `commit` 目的的简短描述，`一定不可` 超过70个字符，`必须` 遵守以下约定：

- `必须` 以动词开头，使用第一人称现在时，例如使用 `修改` 而不是 `修改了` 或者 `一些修改`
- `应该` 使用中文，且中文文案排版 `必须` 符合 [「中文文案排版指北」](https://github.com/sparanoid/chinese-copywriting-guidelines/blob/master/README.zh-CN.md)
- 结尾 `一定不可` 加句号（.）

示例：

```
添加 `task:stat` 定时任务，用以统计威客平台任务数 
```

#### 头部示例

不包含「作用域」的「头部」：

```
feat: 添加 `task:stat` 定时任务，用以统计威客平台任务数
```

包含「作用域」的「头部」：

```
fix(user.login): 修改用户登录逻辑，以解决密码错误验证上限不正确的问题
```

### 「正文」

「正文」 部分是对本次 `commit` 的详细描述，可以分成多行。注意以下几点：

- `必须` 以动词开头，使用第一人称现在时，例如使用 `修改` 而不是 `修改了` 或者 `一些修改`
- `应该` 使用中文，且中文文案排版 `必须` 符合 [「中文文案排版指北」](https://github.com/sparanoid/chinese-copywriting-guidelines/blob/master/README.zh-CN.md)
- `应该` 包含这次变化的动机以及与之前行为的对比
- `必须` 符合 [`Markdown`](https://markdown.cn/) 语法

示例：

```

```

### 「脚注」

「脚注」包含任何**「不兼容变动」**，以及本次提交关闭的 `Issue`：

- 「不兼容变动」

  如果当前提交的代码与上一个版本不兼容，`必须` 在「脚注」中给出说明，内容包含：对变动的描述、变动理由和迁移方法;以 `BREAKING CHANGE`开头。

  示例，摘抄自 [`angular` 提交历史](https://github.com/angular/angular.js/commit/73c6467f1468353215dc689c019ed83aa4993c77)：


```
BREAKING CHNAGE:

移除 `$cookieStore` 变量，迁移至 `$cookie` 服务。注意：
对象值，需要使用`putObject`和`getObject`方法进行`get`、`put`操作，否则将无法正确保存、检索它们。

修改前：

$cookieStore.put('name', {key: 'value'});
$cookieStore.get('name'); // {key: 'value'}
$cookieStore.remove('name');

修改后：

$cookies.putObject('name', {key: 'value'});
$cookies.getObject('name'); // {key: 'value'}
$cookies.remove('name');
```


- 关闭 `Issue`
  
  如果当前提交是针对某个 `Issue`，`必须` 在「脚注」部分关闭这个 `Issue`,以单词 `Closes` 开头。
  
  关闭单个 `Issue` 示例：

  ```
  Closes #65927
  ```

  关闭多个 `Issue` 示例（参考 [`angular` 提交历史](https://github.com/angular/angular.js/commit/5b11145473da01c69b50cc08f1202b5b6be904b1)）：
  
  ```
  Closes #16601
  Fixes #14749
  Closes #14517
  Closes #13202
  ```

## 为什么使用约定式提交

* 自动化生成 `CHANGELOG`。
* 基于提交的类型，自动决定语义化的版本变更。
* 向同事、公众与其他利益关系者传达变化的性质。
* 触发构建和部署流程。
* 让人们探索一个更加结构化的提交历史，以便降低对你的项目做出贡献的难 度。

## FAQ

### 如果提交符合多种类型我该如何操作？

回退并尽可能创建多次提交。约定式提交的好处之一是能够促使我们做出更有组织的提交和 `PR`。

### 这不会阻碍快速开发和迭代吗？

它阻碍的是以杂乱无章的方式快速前进。它助你能在横跨多个项目以及和多个贡献者协作时长期地快速演进。

## 参考文档

- [约定式提交规范](https://www.conventionalcommits.org)
- [angular Git Commit Guidelines](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines)
- [Commit message 和 Change log 编写指南](https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)