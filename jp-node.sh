python3 - <<'PY'
import json, shutil, time, sys

path = "/etc/v2node/config.json"
backup = f"{path}.bak.{time.strftime('%Y%m%d-%H%M%S')}"
node_id = 202

with open(path, "r", encoding="utf-8") as f:
    cfg = json.load(f)

nodes = cfg.get("Nodes", [])
if not nodes:
    sys.exit("错误：配置中没有现有节点，未执行修改。")

if any(n.get("NodeID") == node_id for n in nodes):
    sys.exit(f"节点 {node_id} 已存在，未重复添加。")

shutil.copy2(path, backup)
new_node = dict(nodes[0])
new_node["NodeID"] = node_id
nodes.append(new_node)

with open(path, "w", encoding="utf-8") as f:
    json.dump(cfg, f, ensure_ascii=False, indent=4)
    f.write("\n")

print(f"已添加节点 {node_id}")
print(f"原配置备份：{backup}")
PY
systemctl restart v2node
systemctl status v2node --no-pager
